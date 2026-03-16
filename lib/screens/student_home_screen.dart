import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:unisphere/app/theme.dart';
import 'package:unisphere/main.dart';
import 'package:unisphere/widgets/theme_toggle_action.dart';

/// Modern student home screen with personalized dashboard.
/// Displays academic overview, quick actions, upcoming classes,
/// assignments, and campus services.
class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isCollapsed) {
      setState(() => _isCollapsed = true);
    } else if (_scrollController.offset <= 100 && _isCollapsed) {
      setState(() => _isCollapsed = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Custom App Bar with greeting
            _buildSliverAppBar(theme, isDark),

            // Quick Stats Cards
            SliverToBoxAdapter(
              child: _buildQuickStats(theme, isDark),
            ),

            // Quick Actions Grid
            SliverToBoxAdapter(
              child: _buildQuickActions(theme, isDark),
            ),

            // Today's Schedule
            SliverToBoxAdapter(
              child: _buildTodaySchedule(theme, isDark),
            ),

            // Upcoming Deadlines
            SliverToBoxAdapter(
              child: _buildUpcomingDeadlines(theme, isDark),
            ),

            // Recent Announcements Preview
            SliverToBoxAdapter(
              child: _buildAnnouncementPreview(theme, isDark),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, bool isDark) {
    final greeting = _getGreeting();

    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark 
          ? UniSphereTheme.surfaceDark 
          : UniSphereTheme.surfaceLight,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                UniSphereTheme.primaryColor,
                UniSphereTheme.primaryDark,
                UniSphereTheme.primaryColor.withAlpha(200),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Alex Johnson',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Computer Science • Year 3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side icons column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Top row: notification and theme toggle
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Show notifications
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const _HeaderThemeToggle(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Profile avatar
                      GestureDetector(
                        onTap: () {
                          // Navigate to profile
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withAlpha(80),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person_rounded,
                              color: UniSphereTheme.primaryColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: _isCollapsed
          ? [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDark ? Colors.white : UniSphereTheme.primaryColor,
                ),
                onPressed: () {},
              ),
              const ThemeToggleAction(),
              const SizedBox(width: 8),
            ]
          : null,
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: const Text('UniSphere'),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Transform.translate(
        offset: const Offset(0, -40),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                theme,
                isDark,
                icon: Icons.grade_rounded,
                label: 'CGPA',
                value: '3.75',
                subValue: '/4.0',
                colors: [
                  const Color(0xFF6C63FF),
                  const Color(0xFF4F46E5),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                theme,
                isDark,
                icon: Icons.calendar_today_rounded,
                label: 'Attendance',
                value: '92',
                subValue: '%',
                colors: [
                  const Color(0xFF06B6D4),
                  const Color(0xFF0891B2),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                theme,
                isDark,
                icon: Icons.assignment_rounded,
                label: 'Due Soon',
                value: '3',
                subValue: ' tasks',
                colors: [
                  const Color(0xFFF472B6),
                  const Color(0xFFDB2777),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withAlpha(200), size: 22),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    subValue,
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, bool isDark) {
    final actions = [
      _QuickActionData(
        icon: Icons.qr_code_scanner_rounded,
        label: 'Scan ID',
        colors: [const Color(0xFF6C63FF), const Color(0xFF4F46E5)],
      ),
      _QuickActionData(
        icon: Icons.menu_book_rounded,
        label: 'Library',
        colors: [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
      ),
      _QuickActionData(
        icon: Icons.restaurant_rounded,
        label: 'Cafeteria',
        colors: [const Color(0xFFF472B6), const Color(0xFFDB2777)],
      ),
      _QuickActionData(
        icon: Icons.directions_bus_rounded,
        label: 'Transport',
        colors: [const Color(0xFF34D399), const Color(0xFF059669)],
      ),
      _QuickActionData(
        icon: Icons.payment_rounded,
        label: 'Fees',
        colors: [const Color(0xFFFBBF24), const Color(0xFFD97706)],
      ),
      _QuickActionData(
        icon: Icons.local_hospital_rounded,
        label: 'Health',
        colors: [const Color(0xFFFF6B6B), const Color(0xFFEF4444)],
      ),
      _QuickActionData(
        icon: Icons.map_rounded,
        label: 'Campus Map',
        colors: [const Color(0xFFA78BFA), const Color(0xFF7C3AED)],
      ),
      _QuickActionData(
        icon: Icons.more_horiz_rounded,
        label: 'More',
        colors: [const Color(0xFF94A3B8), const Color(0xFF64748B)],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(theme, 'Quick Actions', Icons.bolt_rounded),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildQuickActionItem(
                theme,
                isDark,
                icon: action.icon,
                label: action.label,
                colors: action.colors,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String label,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle quick action
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withAlpha(40),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule(ThemeData theme, bool isDark) {
    final todayClasses = _getDummyTodayClasses();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader(
                  theme, "Today's Schedule", Icons.schedule_rounded),
              TextButton(
                onPressed: () {
                  // Navigate to full schedule
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (todayClasses.isEmpty)
            _buildEmptySchedule(theme, isDark)
          else
            ...todayClasses.map(
              (classSession) => _buildClassCard(theme, isDark, classSession),
            ),
        ],
      ),
    );
  }

  Widget _buildClassCard(
      ThemeData theme, bool isDark, _ClassSessionData classData) {
    final isOngoing = classData.isOngoing;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(16),
        border: isOngoing
            ? Border.all(color: UniSphereTheme.success, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(30)
                : UniSphereTheme.primaryColor.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Time column
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: classData.color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    classData.startTime,
                    style: TextStyle(
                      color: classData.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 16,
                    color: classData.color.withAlpha(50),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  Text(
                    classData.endTime,
                    style: TextStyle(
                      color: classData.color.withAlpha(180),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Class info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isOngoing)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: UniSphereTheme.success,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: classData.color.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          classData.type,
                          style: TextStyle(
                            color: classData.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    classData.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 14,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          classData.instructor,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        classData.location,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySchedule(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 48,
            color: UniSphereTheme.success.withAlpha(200),
          ),
          const SizedBox(height: 12),
          Text(
            'No classes today!',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Enjoy your free time',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadlines(ThemeData theme, bool isDark) {
    final deadlines = _getDummyDeadlines();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader(
                  theme, 'Upcoming Deadlines', Icons.assignment_late_rounded),
              TextButton(
                onPressed: () {
                  // Navigate to all deadlines
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...deadlines
              .map((deadline) => _buildDeadlineCard(theme, isDark, deadline)),
        ],
      ),
    );
  }

  Widget _buildDeadlineCard(
      ThemeData theme, bool isDark, _DeadlineData deadline) {
    final isUrgent = deadline.daysLeft <= 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(16),
        border: isUrgent
            ? Border.all(color: UniSphereTheme.error.withAlpha(100), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(30)
                : UniSphereTheme.primaryColor.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: deadline.color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(deadline.icon, color: deadline.color, size: 24),
        ),
        title: Text(
          deadline.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          deadline.course,
          style: theme.textTheme.bodyMedium,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isUrgent
                ? UniSphereTheme.error.withAlpha(20)
                : UniSphereTheme.success.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            deadline.daysLeft == 0
                ? 'Today'
                : deadline.daysLeft == 1
                    ? 'Tomorrow'
                    : '${deadline.daysLeft} days',
            style: TextStyle(
              color: isUrgent ? UniSphereTheme.error : UniSphereTheme.success,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementPreview(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader(
                  theme, 'Announcements', Icons.campaign_rounded),
              TextButton(
                onPressed: () {
                  // Navigate to announcements
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAnnouncementCard(
            theme,
            isDark,
            title: 'Mid-Semester Break Schedule',
            body:
                'The university will be closed from March 15-22 for mid-semester break. All classes will resume on March 23.',
            time: '2 hours ago',
            isPinned: true,
          ),
          _buildAnnouncementCard(
            theme,
            isDark,
            title: 'Library Extended Hours',
            body:
                'The main library will have extended hours (7 AM - 12 AM) during the exam period starting next week.',
            time: '5 hours ago',
            isPinned: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(
    ThemeData theme,
    bool isDark, {
    required String title,
    required String body,
    required String time,
    required bool isPinned,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(30)
                : UniSphereTheme.primaryColor.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isPinned)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: UniSphereTheme.warning.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.push_pin_rounded,
                          size: 12,
                          color: UniSphereTheme.warning,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Pinned',
                          style: TextStyle(
                            color: UniSphereTheme.warning,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                Text(
                  time,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: UniSphereTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  List<_ClassSessionData> _getDummyTodayClasses() {
    return [
      _ClassSessionData(
        name: 'Data Structures & Algorithms',
        instructor: 'Dr. Sarah Mitchell',
        location: 'Hall A-201',
        startTime: '09:00',
        endTime: '10:30',
        type: 'LEC',
        color: const Color(0xFF6C63FF),
        isOngoing: true,
      ),
      _ClassSessionData(
        name: 'Database Systems Lab',
        instructor: 'Prof. John Chen',
        location: 'Lab B-105',
        startTime: '11:00',
        endTime: '12:30',
        type: 'LAB',
        color: const Color(0xFF06B6D4),
        isOngoing: false,
      ),
      _ClassSessionData(
        name: 'Software Engineering',
        instructor: 'Dr. Emily Davis',
        location: 'Hall C-302',
        startTime: '14:00',
        endTime: '15:30',
        type: 'LEC',
        color: const Color(0xFFF472B6),
        isOngoing: false,
      ),
    ];
  }

  List<_DeadlineData> _getDummyDeadlines() {
    return [
      _DeadlineData(
        title: 'Algorithm Analysis Report',
        course: 'Data Structures & Algorithms',
        daysLeft: 2,
        icon: Icons.description_rounded,
        color: UniSphereTheme.error,
      ),
      _DeadlineData(
        title: 'Database Design Project',
        course: 'Database Systems',
        daysLeft: 5,
        icon: Icons.folder_rounded,
        color: UniSphereTheme.warning,
      ),
      _DeadlineData(
        title: 'UI/UX Prototype',
        course: 'Human Computer Interaction',
        daysLeft: 7,
        icon: Icons.design_services_rounded,
        color: UniSphereTheme.success,
      ),
    ];
  }
}

class _QuickActionData {
  final IconData icon;
  final String label;
  final List<Color> colors;

  _QuickActionData({
    required this.icon,
    required this.label,
    required this.colors,
  });
}

class _ClassSessionData {
  final String name;
  final String instructor;
  final String location;
  final String startTime;
  final String endTime;
  final String type;
  final Color color;
  final bool isOngoing;

  _ClassSessionData({
    required this.name,
    required this.instructor,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.color,
    required this.isOngoing,
  });
}

class _DeadlineData {
  final String title;
  final String course;
  final int daysLeft;
  final IconData icon;
  final Color color;

  _DeadlineData({
    required this.title,
    required this.course,
    required this.daysLeft,
    required this.icon,
    required this.color,
  });
}

class _HeaderThemeToggle extends StatelessWidget {
  const _HeaderThemeToggle();

  @override
  Widget build(BuildContext context) {
    final appState = UniSphereApp.of(context);
    final isDark = appState?.isDarkMode ?? false;

    return GestureDetector(
      onTap: appState?.toggleTheme,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(30),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
