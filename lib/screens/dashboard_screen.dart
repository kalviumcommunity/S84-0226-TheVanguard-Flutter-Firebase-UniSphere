import 'package:flutter/material.dart';

import 'package:unisphere/models/dashboard_data.dart';
import 'package:unisphere/widgets/event_card.dart';
import 'package:unisphere/widgets/announcement_tile.dart';
import 'package:unisphere/widgets/empty_state.dart';
import 'package:unisphere/widgets/theme_toggle_action.dart';

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
        actions: const [
          ThemeToggleAction(),
          SizedBox(width: 4),
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
              buildSearchBar(theme),
              const SizedBox(height: 24),

              // ── Upcoming Events section ─────────────────────
              buildSectionHeader(
                theme,
                title: 'Upcoming Events',
                icon: Icons.event_rounded,
              ),
              const SizedBox(height: 14),

              // Event list or empty/loading state
              if (_isLoading)
                ...buildShimmerCards(3)
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
                  buildSectionHeader(
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
                ...buildShimmerCards(2, height: 100)
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
  Widget buildSearchBar(ThemeData theme) {
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
  Widget buildSectionHeader(
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
  List<Widget> buildShimmerCards(int count, {double height = 160}) {
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
