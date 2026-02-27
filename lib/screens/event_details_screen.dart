import 'package:flutter/material.dart';

import '../main.dart';
import 'dashboard_screen.dart';

/// Displays full details for a single event with hero animation,
/// styled register button with animation, and improved typography.
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isRegistered = false;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as EventData;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 20.0;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Collapsible App Bar with gradient hero ──────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 22),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: UniSphereTheme.cardGradients[
                        event.id % UniSphereTheme.cardGradients.length],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding, 60, horizontalPadding, 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Club chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.club,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withAlpha(230),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Event name — large title
                        Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body content ───────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Info cards row ─────────────────────
                  _buildInfoCards(theme, event),
                  const SizedBox(height: 28),

                  // ── Divider ────────────────────────────
                  Divider(
                    color: theme.colorScheme.onSurface.withAlpha(20),
                  ),
                  const SizedBox(height: 20),

                  // ── About section ─────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'About the Event',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),

                  // ── Divider ────────────────────────────
                  Divider(
                    color: theme.colorScheme.onSurface.withAlpha(20),
                  ),
                  const SizedBox(height: 24),

                  // ── Register button with animation ─────
                  AnimatedBuilder(
                    animation: _buttonScale,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonScale.value,
                        child: SizedBox(
                          width: double.infinity,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            decoration: BoxDecoration(
                              gradient: _isRegistered
                                  ? const LinearGradient(
                                      colors: [
                                        UniSphereTheme.success,
                                        UniSphereTheme.successDark,
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: UniSphereTheme.cardGradients[
                                          event.id %
                                              UniSphereTheme
                                                  .cardGradients.length],
                                    ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isRegistered
                                          ? UniSphereTheme.success
                                          : theme.colorScheme.primary)
                                      .withAlpha(60),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTapDown: (_) => _buttonController.forward(),
                                onTapUp: (_) => _buttonController.reverse(),
                                onTapCancel: () => _buttonController.reverse(),
                                onTap: _isRegistered
                                    ? null
                                    : () {
                                        setState(() => _isRegistered = true);
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    'Successfully registered for ${event.name}!',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                          ),
                                        );
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: Icon(
                                          _isRegistered
                                              ? Icons.check_circle_rounded
                                              : Icons.app_registration_rounded,
                                          key: ValueKey(_isRegistered),
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _isRegistered
                                            ? 'Registered!'
                                            : 'Register Now',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the info cards row (date, time, venue).
  Widget _buildInfoCards(ThemeData theme, EventData event) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _infoCard(
              theme,
              icon: Icons.calendar_today_rounded,
              label: 'Date',
              value: event.date,
              width: constraints.maxWidth > 400
                  ? (constraints.maxWidth - 24) / 3
                  : (constraints.maxWidth - 12) / 2,
            ),
            _infoCard(
              theme,
              icon: Icons.schedule_rounded,
              label: 'Time',
              value: event.time,
              width: constraints.maxWidth > 400
                  ? (constraints.maxWidth - 24) / 3
                  : (constraints.maxWidth - 12) / 2,
            ),
            _infoCard(
              theme,
              icon: Icons.location_on_rounded,
              label: 'Venue',
              value: event.venue,
              width: constraints.maxWidth > 400
                  ? (constraints.maxWidth - 24) / 3
                  : constraints.maxWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _infoCard(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// Uses AnimatedBuilder from Flutter SDK (named to avoid conflict).
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
