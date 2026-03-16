import 'package:unisphere/models/announcement_model.dart';
import 'package:unisphere/repositories/announcement_repository.dart';

/// Mock implementation of [AnnouncementRepository] using in-memory data.
class MockAnnouncementRepository implements AnnouncementRepository {
  final List<AnnouncementModel> _announcements = List.from(_seedAnnouncements);

  @override
  Future<List<AnnouncementModel>> getAnnouncements({String? clubId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (clubId != null) {
      return _announcements.where((a) => a.clubId == clubId).toList();
    }
    return List.from(_announcements);
  }

  @override
  Future<AnnouncementModel> createAnnouncement(
      AnnouncementModel announcement) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newAnnouncement =
        announcement.copyWith(id: 'ann_${_announcements.length}');
    _announcements.insert(0, newAnnouncement);
    return newAnnouncement;
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _announcements.removeWhere((a) => a.id == id);
  }
}

/// Seed data — mirrors original dummyAnnouncements.
const List<AnnouncementModel> _seedAnnouncements = [
  AnnouncementModel(
    id: 'ann_0',
    title: 'Club Registrations Open',
    postedBy: 'Student Council',
    date: 'Feb 20, 2026',
    description:
        'Registrations for all campus clubs are now open for the spring '
        'semester. Visit the student portal to sign up before Feb 28.',
    priority: AnnouncementPriority.important,
  ),
  AnnouncementModel(
    id: 'ann_1',
    title: 'Library Extended Hours',
    postedBy: 'Admin Office',
    date: 'Feb 18, 2026',
    description:
        'The central library will remain open until 11 PM on weekdays '
        'during the exam preparation period starting March 1.',
  ),
  AnnouncementModel(
    id: 'ann_2',
    title: 'Sports Day Announcement',
    postedBy: 'Sports Committee',
    date: 'Feb 15, 2026',
    description:
        'Annual Sports Day is scheduled for April 10. Interested '
        'students should register with their department coordinator.',
  ),
  AnnouncementModel(
    id: 'ann_3',
    title: 'Guest Lecture: Cloud Computing',
    postedBy: 'CS Department',
    date: 'Feb 12, 2026',
    description:
        'A guest lecture on cloud-native architecture by an industry '
        'expert will be held on March 8 in Seminar Hall B.',
  ),
  AnnouncementModel(
    id: 'ann_4',
    title: 'Cafeteria Menu Update',
    postedBy: 'Hostel Committee',
    date: 'Feb 10, 2026',
    description:
        'New healthy meal options have been added to the cafeteria menu '
        'starting this week. Check the notice board for details.',
  ),
];
