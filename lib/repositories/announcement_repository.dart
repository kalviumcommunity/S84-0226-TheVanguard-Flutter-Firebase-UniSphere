import '../models/announcement_model.dart';

/// Abstract contract for announcement data operations.
abstract class AnnouncementRepository {
  /// Returns all announcements, optionally filtered by [clubId].
  Future<List<AnnouncementModel>> getAnnouncements({String? clubId});

  /// Creates a new announcement. Returns it with its assigned ID.
  Future<AnnouncementModel> createAnnouncement(AnnouncementModel announcement);

  /// Deletes an announcement by [id].
  Future<void> deleteAnnouncement(String id);
}
