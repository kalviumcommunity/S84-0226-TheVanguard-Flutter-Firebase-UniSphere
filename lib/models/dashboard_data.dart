/// Lightweight UI-facing event model used by dashboard-related demo screens.
class EventData {
  final int id;
  final String name;
  final String club;
  final String date;
  final String time;
  final String venue;
  final String description;

  const EventData({
    required this.id,
    required this.name,
    required this.club,
    required this.date,
    required this.time,
    required this.venue,
    required this.description,
  });
}

/// Lightweight UI-facing announcement model used by list/tile widgets.
class AnnouncementData {
  final String title;
  final String postedBy;
  final String date;
  final String description;

  const AnnouncementData({
    required this.title,
    required this.postedBy,
    required this.date,
    required this.description,
  });
}

/// Hardcoded event list used by the current dashboard flow.
const List<EventData> dummyEvents = [
  EventData(
    id: 0,
    name: 'Flutter Workshop',
    club: 'Google DSC',
    date: 'Mar 5, 2026',
    time: '10:00 AM – 1:00 PM',
    venue: 'Seminar Hall A',
    description:
        'A hands-on workshop covering Flutter basics, widget trees, '
        'state management, and building a complete app from scratch.',
  ),
  EventData(
    id: 1,
    name: 'AI Hackathon',
    club: 'AI Club',
    date: 'Mar 12, 2026',
    time: '9:00 AM – 6:00 PM',
    venue: 'Innovation Lab',
    description:
        'A full-day hackathon where teams build AI-powered prototypes. '
        'Prizes for the top three teams. Bring your laptop!',
  ),
  EventData(
    id: 2,
    name: 'Photography Walk',
    club: 'Lens Club',
    date: 'Mar 18, 2026',
    time: '4:00 PM – 6:30 PM',
    venue: 'Campus Gardens',
    description:
        'An outdoor photography session exploring composition, lighting, '
        'and mobile photography tips with the Lens Club mentors.',
  ),
  EventData(
    id: 3,
    name: 'Debate Championship',
    club: 'Literary Society',
    date: 'Mar 25, 2026',
    time: '2:00 PM – 5:00 PM',
    venue: 'Auditorium',
    description:
        'Inter-department debate competition on current affairs. '
        'Open to all years. Register as individual or pair.',
  ),
  EventData(
    id: 4,
    name: 'Cybersecurity Bootcamp',
    club: 'InfoSec Club',
    date: 'Apr 2, 2026',
    time: '11:00 AM – 3:00 PM',
    venue: 'Computer Lab 3',
    description:
        'Learn ethical hacking fundamentals, network scanning, and '
        'vulnerability assessment in this beginner-friendly bootcamp.',
  ),
];

/// Hardcoded announcements list used by dashboard and announcements screens.
const List<AnnouncementData> dummyAnnouncements = [
  AnnouncementData(
    title: 'Club Registrations Open',
    postedBy: 'Student Council',
    date: 'Feb 20, 2026',
    description:
        'Registrations for all campus clubs are now open for the spring '
        'semester. Visit the student portal to sign up before Feb 28.',
  ),
  AnnouncementData(
    title: 'Library Extended Hours',
    postedBy: 'Admin Office',
    date: 'Feb 18, 2026',
    description:
        'The central library will remain open until 11 PM on weekdays '
        'during the exam preparation period starting March 1.',
  ),
  AnnouncementData(
    title: 'Sports Day Announcement',
    postedBy: 'Sports Committee',
    date: 'Feb 15, 2026',
    description:
        'Annual Sports Day is scheduled for April 10. Interested '
        'students should register with their department coordinator.',
  ),
  AnnouncementData(
    title: 'Guest Lecture: Cloud Computing',
    postedBy: 'CS Department',
    date: 'Feb 12, 2026',
    description:
        'A guest lecture on cloud-native architecture by an industry '
        'expert will be held on March 8 in Seminar Hall B.',
  ),
  AnnouncementData(
    title: 'Cafeteria Menu Update',
    postedBy: 'Hostel Committee',
    date: 'Feb 10, 2026',
    description:
        'New healthy meal options have been added to the cafeteria menu '
        'starting this week. Check the notice board for details.',
  ),
];
