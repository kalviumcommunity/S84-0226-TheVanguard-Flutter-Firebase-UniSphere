import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/attendance_model.dart';
import '../attendance_repository.dart';

/// Firebase Firestore implementation of [AttendanceRepository].
///
/// Collection: `attendance/{attendanceId}`
///
/// Each document records a check-in for a user at an event.
class FirebaseAttendanceRepository implements AttendanceRepository {
  final FirebaseFirestore _db;

  FirebaseAttendanceRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _attendanceCollection =>
      _db.collection('attendance');

  @override
  Future<List<AttendanceModel>> getEventAttendance(String eventId) async {
    final snapshot = await _attendanceCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('checkInTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<AttendanceModel> checkIn(
    String userId,
    String eventId,
    CheckInMethod method,
  ) async {
    // Check if already checked in
    final existing = await _findCheckIn(userId, eventId);
    if (existing != null) {
      return existing; // Already checked in
    }

    final attendance = AttendanceModel(
      id: '', // Will be set by Firestore
      userId: userId,
      eventId: eventId,
      checkInTime: DateTime.now(),
      method: method,
    );

    final docRef = await _attendanceCollection.add({
      ...attendance.toMap(),
      'checkInTime': FieldValue.serverTimestamp(),
    });

    return AttendanceModel(
      id: docRef.id,
      userId: userId,
      eventId: eventId,
      checkInTime: DateTime.now(),
      method: method,
    );
  }

  @override
  Future<bool> hasCheckedIn(String userId, String eventId) async {
    final existing = await _findCheckIn(userId, eventId);
    return existing != null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helper Methods
  // ─────────────────────────────────────────────────────────────────────────

  /// Finds an existing check-in for a user-event pair.
  Future<AttendanceModel?> _findCheckIn(String userId, String eventId) async {
    final snapshot = await _attendanceCollection
        .where('userId', isEqualTo: userId)
        .where('eventId', isEqualTo: eventId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return AttendanceModel.fromMap(doc.data(), docId: doc.id);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Additional Methods
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a single attendance record by [id].
  Future<AttendanceModel?> getAttendanceById(String id) async {
    final doc = await _attendanceCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return AttendanceModel.fromMap(doc.data()!, docId: doc.id);
  }

  /// Returns all attendance records for a user across all events.
  Future<List<AttendanceModel>> getUserAttendance(String userId) async {
    final snapshot = await _attendanceCollection
        .where('userId', isEqualTo: userId)
        .orderBy('checkInTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  /// Returns attendance count for an event.
  Future<int> getEventAttendanceCount(String eventId) async {
    final snapshot = await _attendanceCollection
        .where('eventId', isEqualTo: eventId)
        .count()
        .get();
    
    return snapshot.count ?? 0;
  }

  /// Deletes an attendance record (for admin corrections).
  Future<void> deleteAttendance(String id) async {
    await _attendanceCollection.doc(id).delete();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Real-time Streams
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a real-time stream of attendance for an event.
  Stream<List<AttendanceModel>> eventAttendanceStream(String eventId) {
    return _attendanceCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('checkInTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromMap(doc.data(), docId: doc.id))
            .toList());
  }

  /// Returns a real-time stream to check if a user has checked in.
  Stream<bool> hasCheckedInStream(String userId, String eventId) {
    return _attendanceCollection
        .where('userId', isEqualTo: userId)
        .where('eventId', isEqualTo: eventId)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Returns a real-time stream of a user's attendance history.
  Stream<List<AttendanceModel>> userAttendanceStream(String userId) {
    return _attendanceCollection
        .where('userId', isEqualTo: userId)
        .orderBy('checkInTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromMap(doc.data(), docId: doc.id))
            .toList());
  }
}
