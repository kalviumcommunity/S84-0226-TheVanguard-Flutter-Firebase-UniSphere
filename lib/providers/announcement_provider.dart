import 'package:flutter/foundation.dart';

import '../models/announcement_model.dart';
import '../repositories/announcement_repository.dart';

/// Provides centralized announcement state for all screens.
///
/// Holds the announcement list, loading/error states,
/// and CRUD operations delegated to an [AnnouncementRepository].
class AnnouncementProvider extends ChangeNotifier {
  final AnnouncementRepository _repository;

  AnnouncementProvider(this._repository);

  // ── State ────────────────────────────────────────────────────

  List<AnnouncementModel> _announcements = [];
  bool _isLoading = false;
  String? _error;

  // ── Getters ──────────────────────────────────────────────────

  List<AnnouncementModel> get announcements =>
      List.unmodifiable(_announcements);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Returns the most recent [count] announcements (for dashboard preview).
  List<AnnouncementModel> preview([int count = 3]) {
    return _announcements.take(count).toList();
  }

  // ── Actions ──────────────────────────────────────────────────

  /// Loads all announcements, optionally filtered by [clubId].
  Future<void> loadAnnouncements({String? clubId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _announcements =
          await _repository.getAnnouncements(clubId: clubId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load announcements: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new announcement (admin action).
  Future<AnnouncementModel?> createAnnouncement(
      AnnouncementModel announcement) async {
    try {
      final created = await _repository.createAnnouncement(announcement);
      _announcements.insert(0, created);
      notifyListeners();
      return created;
    } catch (e) {
      _error = 'Failed to create announcement: $e';
      notifyListeners();
      return null;
    }
  }

  /// Deletes an announcement (admin action).
  Future<bool> deleteAnnouncement(String id) async {
    try {
      await _repository.deleteAnnouncement(id);
      _announcements.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete announcement: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
