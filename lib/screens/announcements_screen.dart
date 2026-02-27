import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/announcement_tile.dart';
import '../widgets/empty_state.dart';
import 'dashboard_screen.dart';

/// Full-page scrollable list of all announcements with
/// pull-to-refresh and polished visual hierarchy.
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate initial loading
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 18.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Announcements'),
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
        child: _isLoading
            ? _buildLoadingState()
            : dummyAnnouncements.isEmpty
                ? const CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyState(
                          icon: Icons.campaign_outlined,
                          title: 'No announcements',
                          subtitle: 'Check back later for updates',
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16,
                    ),
                    itemCount: dummyAnnouncements.length,
                    itemBuilder: (context, index) {
                      final item = dummyAnnouncements[index];
                      return AnnouncementTile(
                        announcement: item,
                        showFullDescription: true,
                      );
                    },
                  ),
      ),
    );
  }

  /// Builds a pulsing loading placeholder.
  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: 4,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.3, end: 0.8),
          duration: Duration(milliseconds: 1000 + (index * 150)),
          curve: Curves.easeInOut,
          builder: (context, value, _) {
            return AnimatedOpacity(
              opacity: value,
              duration: const Duration(milliseconds: 400),
              child: Container(
                height: 100,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withAlpha(15),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
