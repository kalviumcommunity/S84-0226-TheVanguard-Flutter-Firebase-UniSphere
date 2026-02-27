import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/event_card.dart';
import '../widgets/announcement_tile.dart';
import '../widgets/empty_state.dart';

// ═════════════════════════════════════════════════════════════════
//  DATA MODELS — shared across screens
// ═════════════════════════════════════════════════════════════════

/// Dummy event data used across the UniSphere screens.
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

// ═════════════════════════════════════════════════════════════════
//  DASHBOARD SCREEN — upgraded with search, filters, polish
// ═════════════════════════════════════════════════════════════════

/// The main dashboard / home screen for UniSphere.
///
/// Displays upcoming events and recent announcements with
/// search/filter, pull-to-refresh, and smooth scrolling.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate initial data loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filters events by title based on user search query.
  List<EventData> get _filteredEvents {
    if (_searchQuery.isEmpty) return dummyEvents;
    return dummyEvents
        .where((e) =>
            e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            e.club.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  /// Simulates a pull-to-refresh action.
  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 18.0;
    final filteredEvents = _filteredEvents;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('UniSphere'),
        actions: [
          // Dark mode toggle
          IconButton(
            icon: Icon(
              UniSphereApp.of(context)?.isDarkMode == true
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: 'Toggle theme',
            onPressed: () => UniSphereApp.of(context)?.toggleTheme(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search Bar ──────────────────────────────────
              _buildSearchBar(theme),
              const SizedBox(height: 24),

              // ── Upcoming Events section ─────────────────────
              _buildSectionHeader(
                theme,
                title: 'Upcoming Events',
                icon: Icons.event_rounded,
              ),
              const SizedBox(height: 14),

              // Event list or empty/loading state
              if (_isLoading)
                ..._buildShimmerCards(3)
              else if (filteredEvents.isEmpty)
                const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No events found',
                  subtitle: 'Try a different search term',
                )
              else
                ...filteredEvents.asMap().entries.map((entry) {
                  return EventCard(
                    event: entry.value,
                    index: entry.key,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/event-details',
                        arguments: entry.value,
                      );
                    },
                  );
                }),
              const SizedBox(height: 28),

              // ── Recent Announcements section ────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader(
                    theme,
                    title: 'Announcements',
                    icon: Icons.campaign_rounded,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/announcements');
                    },
                    icon: const Text('View All'),
                    label: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (_isLoading)
                ..._buildShimmerCards(2, height: 100)
              else
                ...dummyAnnouncements
                    .take(3)
                    .map((item) => AnnouncementTile(announcement: item)),

              // Bottom spacing for scroll
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the futuristic search bar UI.
  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search events, clubs...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(100),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.primary,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: theme.colorScheme.onSurface.withAlpha(120),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
      ),
    );
  }

  /// Builds a section header with icon and title.
  Widget _buildSectionHeader(
    ThemeData theme, {
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Text(title, style: theme.textTheme.titleLarge),
      ],
    );
  }

  /// Builds shimmer placeholder cards for loading state.
  List<Widget> _buildShimmerCards(int count, {double height = 160}) {
    return List.generate(count, (i) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.3, end: 0.8),
        duration: Duration(milliseconds: 1000 + (i * 200)),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return AnimatedOpacity(
            opacity: value,
            duration: const Duration(milliseconds: 400),
            child: Container(
              width: double.infinity,
              height: height,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.onSurface.withAlpha(15),
              ),
            ),
          );
        },
      );
    });
  }
}
