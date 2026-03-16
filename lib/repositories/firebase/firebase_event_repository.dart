import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:unisphere/models/event_model.dart';
import 'package:unisphere/repositories/event_repository.dart';

/// Firebase Firestore implementation of [EventRepository].
///
/// Collection: `events/{eventId}`
class FirebaseEventRepository implements EventRepository {
  final FirebaseFirestore _db;
  
  FirebaseEventRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsCollection =>
      _db.collection('events');

  @override
  Future<List<EventModel>> getEvents({
    String? clubId,
    EventStatus? status,
  }) async {
    Query<Map<String, dynamic>> query = _eventsCollection;

    if (clubId != null) {
      query = query.where('clubId', isEqualTo: clubId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => EventModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<EventModel?> getEventById(String id) async {
    final doc = await _eventsCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return EventModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<EventModel> createEvent(EventModel event) async {
    final docRef = await _eventsCollection.add({
      ...event.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return event.copyWith(id: docRef.id);
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    await _eventsCollection.doc(event.id).update({
      ...event.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _eventsCollection.doc(id).delete();
  }

  @override
  Future<List<EventModel>> searchEvents(String query) async {
    // Firestore doesn't support full-text search natively.
    // Fetch all events and filter client-side, or use Algolia/Typesense.
    final snapshot = await _eventsCollection.get();
    final lowerQuery = query.toLowerCase();
    return snapshot.docs
        .map((doc) => EventModel.fromMap(doc.data(), docId: doc.id))
        .where((e) =>
            e.name.toLowerCase().contains(lowerQuery) ||
            e.club.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Real-time Streams
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a real-time stream of all events, optionally filtered.
  Stream<List<EventModel>> eventsStream({
    String? clubId,
    EventStatus? status,
  }) {
    Query<Map<String, dynamic>> query = _eventsCollection;

    if (clubId != null) {
      query = query.where('clubId', isEqualTo: clubId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => EventModel.fromMap(doc.data(), docId: doc.id))
        .toList());
  }

  /// Returns a real-time stream for a single event.
  Stream<EventModel?> eventStream(String id) {
    return _eventsCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return EventModel.fromMap(doc.data()!, docId: doc.id);
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Capacity Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Increments the registered count for an event (used during registration).
  Future<void> incrementRegisteredCount(String eventId) async {
    await _eventsCollection.doc(eventId).update({
      'registeredCount': FieldValue.increment(1),
    });
  }

  /// Decrements the registered count for an event (used during cancellation).
  Future<void> decrementRegisteredCount(String eventId) async {
    await _eventsCollection.doc(eventId).update({
      'registeredCount': FieldValue.increment(-1),
    });
  }
}
