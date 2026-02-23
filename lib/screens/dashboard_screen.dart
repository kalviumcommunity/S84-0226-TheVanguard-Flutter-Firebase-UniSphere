import 'package:flutter/material.dart';

/// Dummy event data used across the Campus Connect screens.
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

/// Dummy announcement data.
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

/// Hardcoded event list.
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

/// Hardcoded announcements list.
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

/// The main dashboard / home screen for Campus Connect.
///
/// Displays upcoming events and recent announcements using
/// [ListView.builder] inside a scrollable layout.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth > 600 ? 32.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Connect'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign),
            tooltip: 'Announcements',
            onPressed: () {
              Navigator.pushNamed(context, '/announcements');
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Attendance',
            onPressed: () {
              Navigator.pushNamed(context, '/attendance');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Upcoming Events ────────────────────────────
            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              itemCount: dummyEvents.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final event = dummyEvents[index];
                return _EventCard(
                  event: event,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/event-details',
                      arguments: event,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // ── Recent Announcements ──────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Announcements',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/announcements');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              itemCount:
                  dummyAnnouncements.length > 3 ? 3 : dummyAnnouncements.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = dummyAnnouncements[index];
                return _AnnouncementTile(announcement: item);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ──────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final EventData event;
  final VoidCallback onTap;

  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date badge
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    event.date.split(' ')[1].replaceAll(',', ''),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Event info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.club}  •  ${event.date}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Register arrow
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  final AnnouncementData announcement;

  const _AnnouncementTile({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${announcement.postedBy}  •  ${announcement.date}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Text(
              announcement.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
