import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class for all Firestore (Cloud Firestore) operations.
///
/// Covers:
///   • User profile document (create / read)
///   • Notes collection per user (create / read stream / update / delete)
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─────────────────────────────────────────────────────────────────────────
  // User profile
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates or overwrites a user document at `users/{uid}`.
  ///
  /// Typical [data] map: `{'name': '...', 'email': '...', 'createdAt': ...}`
  Future<void> addUserData(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data);
  }

  /// Returns a user document snapshot for [uid], or null if it doesn't exist.
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Notes (per-user collection: users/{uid}/notes/{noteId})
  // ─────────────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _notesCollection(String uid) =>
      _db.collection('users').doc(uid).collection('notes');

  // ── Create ────────────────────────────────────────────────────────────────

  /// Adds a new note for [uid] and returns the generated document ID.
  Future<String> addNote(String uid, String title, String content) async {
    final doc = await _notesCollection(uid).add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // ── Read (real-time stream) ───────────────────────────────────────────────

  /// Returns a real-time [Stream] of all notes for [uid],
  /// ordered by most-recently created first.
  Stream<QuerySnapshot<Map<String, dynamic>>> notesStream(String uid) {
    return _notesCollection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ── Update ────────────────────────────────────────────────────────────────

  /// Updates the [title] and/or [content] of an existing note [noteId] for [uid].
  Future<void> updateNote(
    String uid,
    String noteId, {
    required String title,
    required String content,
  }) async {
    await _notesCollection(uid).doc(noteId).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  /// Permanently deletes note [noteId] belonging to [uid].
  Future<void> deleteNote(String uid, String noteId) async {
    await _notesCollection(uid).doc(noteId).delete();
  }
}
