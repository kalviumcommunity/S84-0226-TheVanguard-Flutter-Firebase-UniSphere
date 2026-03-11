import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/announcement_model.dart';
import '../announcement_repository.dart';

/// Firebase Firestore implementation of [AnnouncementRepository].
///
/// Collection: `announcements/{announcementId}`
class FirebaseAnnouncementRepository implements AnnouncementRepository {
  final FirebaseFirestore _db;

  FirebaseAnnouncementRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _announcementsCollection =>
      _db.collection('announcements');

  @override
  Future<List<AnnouncementModel>> getAnnouncements({String? clubId}) async {
    Query<Map<String, dynamic>> query = _announcementsCollection
        .orderBy('createdAt', descending: true);

    if (clubId != null) {
      query = query.where('clubId', isEqualTo: clubId);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => AnnouncementModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<AnnouncementModel> createAnnouncement(
      AnnouncementModel announcement) async {
    final docRef = await _announcementsCollection.add({
      ...announcement.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return announcement.copyWith(id: docRef.id);
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    await _announcementsCollection.doc(id).delete();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Additional methods not in base interface
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a single announcement by [id].
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    final doc = await _announcementsCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return AnnouncementModel.fromMap(doc.data()!, docId: doc.id);
  }

  /// Updates an existing announcement.
  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    await _announcementsCollection.doc(announcement.id).update({
      ...announcement.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Real-time Streams
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a real-time stream of announcements, optionally filtered by club.
  Stream<List<AnnouncementModel>> announcementsStream({String? clubId}) {
    Query<Map<String, dynamic>> query = _announcementsCollection
        .orderBy('createdAt', descending: true);

    if (clubId != null) {
      query = query.where('clubId', isEqualTo: clubId);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => AnnouncementModel.fromMap(doc.data(), docId: doc.id))
        .toList());
  }

  /// Returns a real-time stream for a single announcement.
  Stream<AnnouncementModel?> announcementStream(String id) {
    return _announcementsCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return AnnouncementModel.fromMap(doc.data()!, docId: doc.id);
    });
  }

  /// Returns announcements filtered by priority.
  Future<List<AnnouncementModel>> getAnnouncementsByPriority(
      AnnouncementPriority priority) async {
    final snapshot = await _announcementsCollection
        .where('priority', isEqualTo: priority.name)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }
}
