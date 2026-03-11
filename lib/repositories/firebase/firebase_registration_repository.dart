import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/registration_model.dart';
import '../registration_repository.dart';
import 'firebase_event_repository.dart';

/// Firebase Firestore implementation of [RegistrationRepository].
///
/// Collection: `registrations/{registrationId}`
///
/// Composite key approach: Each registration document stores userId + eventId.
/// Query by userId or eventId using Firestore indexes.
class FirebaseRegistrationRepository implements RegistrationRepository {
  final FirebaseFirestore _db;
  final FirebaseEventRepository? _eventRepository;

  FirebaseRegistrationRepository({
    FirebaseFirestore? firestore,
    FirebaseEventRepository? eventRepository,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _eventRepository = eventRepository;

  CollectionReference<Map<String, dynamic>> get _registrationsCollection =>
      _db.collection('registrations');

  @override
  Future<List<RegistrationModel>> getUserRegistrations(String userId) async {
    final snapshot = await _registrationsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isNotEqualTo: RegistrationStatus.cancelled.name)
        .orderBy('status')
        .orderBy('registeredAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RegistrationModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<List<RegistrationModel>> getEventRegistrations(String eventId) async {
    final snapshot = await _registrationsCollection
        .where('eventId', isEqualTo: eventId)
        .where('status', isNotEqualTo: RegistrationStatus.cancelled.name)
        .orderBy('status')
        .orderBy('registeredAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RegistrationModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<RegistrationModel> register(String userId, String eventId) async {
    // Check if already registered
    final existing = await _findRegistration(userId, eventId);
    if (existing != null && existing.status != RegistrationStatus.cancelled) {
      return existing; // Already registered
    }

    // If cancelled before, reactivate the registration
    if (existing != null && existing.status == RegistrationStatus.cancelled) {
      await _registrationsCollection.doc(existing.id).update({
        'status': RegistrationStatus.registered.name,
        'registeredAt': FieldValue.serverTimestamp(),
        'cancelledAt': null,
      });
      
      // Update event count
      await _eventRepository?.incrementRegisteredCount(eventId);
      
      return existing.copyWith(
        status: RegistrationStatus.registered,
        registeredAt: DateTime.now(),
        cancelledAt: null,
      );
    }

    // Create new registration
    final registration = RegistrationModel(
      id: '', // Will be set by Firestore
      userId: userId,
      eventId: eventId,
      registeredAt: DateTime.now(),
    );

    final docRef = await _registrationsCollection.add({
      ...registration.toMap(),
      'registeredAt': FieldValue.serverTimestamp(),
    });

    // Update event registered count
    await _eventRepository?.incrementRegisteredCount(eventId);

    return registration.copyWith(id: docRef.id);
  }

  @override
  Future<void> cancelRegistration(String registrationId) async {
    final doc = await _registrationsCollection.doc(registrationId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final eventId = data['eventId'] as String?;

    await _registrationsCollection.doc(registrationId).update({
      'status': RegistrationStatus.cancelled.name,
      'cancelledAt': FieldValue.serverTimestamp(),
    });

    // Update event registered count
    if (eventId != null) {
      await _eventRepository?.decrementRegisteredCount(eventId);
    }
  }

  @override
  Future<RegistrationStatus?> getRegistrationStatus(
      String userId, String eventId) async {
    final registration = await _findRegistration(userId, eventId);
    return registration?.status;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helper Methods
  // ─────────────────────────────────────────────────────────────────────────

  /// Finds an existing registration for a user-event pair.
  Future<RegistrationModel?> _findRegistration(
      String userId, String eventId) async {
    final snapshot = await _registrationsCollection
        .where('userId', isEqualTo: userId)
        .where('eventId', isEqualTo: eventId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return RegistrationModel.fromMap(doc.data(), docId: doc.id);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Real-time Streams
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a real-time stream of a user's registrations.
  Stream<List<RegistrationModel>> userRegistrationsStream(String userId) {
    return _registrationsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: RegistrationStatus.registered.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RegistrationModel.fromMap(doc.data(), docId: doc.id))
            .toList());
  }

  /// Returns a real-time stream of the registration status for a user-event pair.
  Stream<RegistrationStatus?> registrationStatusStream(
      String userId, String eventId) {
    return _registrationsCollection
        .where('userId', isEqualTo: userId)
        .where('eventId', isEqualTo: eventId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final data = snapshot.docs.first.data();
      return RegistrationStatus.fromString(
          data['status'] as String? ?? 'registered');
    });
  }

  /// Returns a real-time stream of registrations for an event.
  Stream<List<RegistrationModel>> eventRegistrationsStream(String eventId) {
    return _registrationsCollection
        .where('eventId', isEqualTo: eventId)
        .where('status', isEqualTo: RegistrationStatus.registered.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RegistrationModel.fromMap(doc.data(), docId: doc.id))
            .toList());
  }
}
