import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/empty_state.dart';
import 'dashboard_screen.dart';

/// Shows a list of all events with their registration status.
///
/// Supports toggle to register/unregister, animated status indicators,
/// and an empty state when no registrations exist.
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  /// Tracks which events the user has registered for.
  /// The first two events are pre-registered for demo purposes.
  final Map<int, bool> _registrations = {
    0: true, // Flutter Workshop
    1: true, // AI Hackathon
  };

  /// Filter: show all or only registered.
  bool _showRegisteredOnly = false;

  List<EventData> get _filteredEvents {
    if (!_showRegisteredOnly) return dummyEvents;
    return dummyEvents
        .where((e) => _registrations[e.id] == true)
        .toList();
  }

  int get _registeredCount =>
      _registrations.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 18.0;
    final filteredEvents = _filteredEvents;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Attendance'),
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
      body: Column(
        children: [
          // ── Summary header ─────────────────────────────
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [UniSphereTheme.primaryColor, UniSphereTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: UniSphereTheme.primaryColor.withAlpha(50),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Animated count badge
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _registeredCount.toDouble()),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registered Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'of ${dummyEvents.length} total events',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Filter toggle row ──────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showRegisteredOnly ? 'Registered Only' : 'All Events',
                  style: theme.textTheme.titleMedium,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _showRegisteredOnly = !_showRegisteredOnly);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _showRegisteredOnly
                          ? theme.colorScheme.primary.withAlpha(20)
                          : theme.colorScheme.onSurface.withAlpha(10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _showRegisteredOnly
                            ? theme.colorScheme.primary.withAlpha(60)
                            : theme.colorScheme.onSurface.withAlpha(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showRegisteredOnly
                              ? Icons.filter_alt_rounded
                              : Icons.filter_alt_off_rounded,
                          size: 16,
                          color: _showRegisteredOnly
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withAlpha(120),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _showRegisteredOnly
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withAlpha(120),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Event list ─────────────────────────────────
          Expanded(
            child: filteredEvents.isEmpty
                ? const EmptyState(
                    icon: Icons.event_busy_rounded,
                    title: 'No registrations yet',
                    subtitle: 'Register for events from the Dashboard',
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      final bool registered =
                          _registrations[event.id] ?? false;

                      return _AttendanceCard(
                        event: event,
                        registered: registered,
                        onToggle: () {
                          setState(() {
                            _registrations[event.id] = !registered;
                          });
                          // Show feedback snackbar
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    !registered
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      !registered
                                          ? 'Registered for ${event.name}'
                                          : 'Unregistered from ${event.name}',
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Individual attendance card with toggle + animated indicators
// ─────────────────────────────────────────────────────────────────

class _AttendanceCard extends StatelessWidget {
  final EventData event;
  final bool registered;
  final VoidCallback onToggle;

  const _AttendanceCard({
    required this.event,
    required this.registered,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ── Animated status indicator ──
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: registered
                      ? const LinearGradient(
                          colors: [
                            UniSphereTheme.success,
                            UniSphereTheme.successDark,
                          ],
                        )
                      : null,
                  color: registered
                      ? null
                      : theme.colorScheme.onSurface.withAlpha(15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    registered
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    key: ValueKey(registered),
                    color: registered
                        ? Colors.white
                        : theme.colorScheme.onSurface.withAlpha(80),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // ── Event info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.groups_rounded,
                          size: 13,
                          color: theme.textTheme.labelSmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.club,
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: theme.textTheme.labelSmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.date,
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Status chip ──
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: registered
                      ? UniSphereTheme.success.withAlpha(25)
                      : theme.colorScheme.onSurface.withAlpha(10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: registered
                        ? UniSphereTheme.success.withAlpha(60)
                        : theme.colorScheme.onSurface.withAlpha(20),
                  ),
                ),
                child: Text(
                  registered ? 'Registered' : 'Not Registered',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: registered
                        ? UniSphereTheme.success
                        : theme.colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
