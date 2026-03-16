import 'package:flutter/material.dart';

import 'package:unisphere/app/theme.dart';
import 'package:unisphere/widgets/theme_toggle_action.dart';

/// Weekly class schedule screen with a beautiful timetable view.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDayIndex = DateTime.now().weekday - 1; // 0 = Monday

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> _fullDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: _selectedDayIndex.clamp(0, 5),
    );
    _tabController.addListener(() {
      setState(() => _selectedDayIndex = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Schedule'),
        actions: const [
          ThemeToggleAction(),
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildDaySelector(theme, isDark),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(6, (index) {
          return _buildDaySchedule(theme, isDark, index);
        }),
      ),
    );
  }

  Widget _buildDaySelector(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withAlpha(10)
            : Colors.white.withAlpha(80),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              UniSphereTheme.primaryColor,
              UniSphereTheme.primaryDark,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: UniSphereTheme.primaryColor.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: _days.map((day) => Tab(text: day)).toList(),
      ),
    );
  }

  Widget _buildDaySchedule(ThemeData theme, bool isDark, int dayIndex) {
    final classes = _getClassesForDay(dayIndex);
    final isToday = DateTime.now().weekday - 1 == dayIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Row(
            children: [
              Text(
                _fullDays[dayIndex],
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isToday)
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: UniSphereTheme.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${classes.length} classes scheduled',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Timeline view
          if (classes.isEmpty)
            _buildNoClassesMessage(theme, isDark)
          else
            _buildTimelineView(theme, isDark, classes),
        ],
      ),
    );
  }

  Widget _buildNoClassesMessage(ThemeData theme, bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        margin: const EdgeInsets.only(top: 48),
        decoration: BoxDecoration(
          color: isDark
              ? UniSphereTheme.cardColorDark
              : UniSphereTheme.cardColorLight,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: UniSphereTheme.success.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.beach_access_rounded,
                size: 40,
                color: UniSphereTheme.success,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Classes!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy your free day',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineView(
    ThemeData theme,
    bool isDark,
    List<_ScheduleClass> classes,
  ) {
    return Column(
      children: classes.asMap().entries.map((entry) {
        final index = entry.key;
        final classData = entry.value;
        final isLast = index == classes.length - 1;

        return _buildTimelineItem(theme, isDark, classData, isLast);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(
    ThemeData theme,
    bool isDark,
    _ScheduleClass classData,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Text(
                  classData.startTime,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: classData.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  classData.endTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),

          // Timeline line
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: classData.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: classData.color.withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          classData.color.withAlpha(100),
                          classData.color.withAlpha(30),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Class card
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? UniSphereTheme.cardColorDark
                    : UniSphereTheme.cardColorLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: classData.color.withAlpha(30),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withAlpha(30)
                        : classData.color.withAlpha(15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: classData.color.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          classData.type,
                          style: TextStyle(
                            color: classData.color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        classData.duration,
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Course name
                  Text(
                    classData.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    classData.code,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: classData.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info rows
                  _buildInfoRow(
                    Icons.person_outline_rounded,
                    classData.instructor,
                    theme,
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    classData.location,
                    theme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.textTheme.bodyMedium?.color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<_ScheduleClass> _getClassesForDay(int dayIndex) {
    // Return different classes for different days
    final allClasses = {
      0: [
        // Monday
        _ScheduleClass(
          name: 'Data Structures & Algorithms',
          code: 'CS 301',
          instructor: 'Dr. Sarah Mitchell',
          location: 'Hall A-201',
          startTime: '09:00',
          endTime: '10:30',
          duration: '1h 30m',
          type: 'LECTURE',
          color: const Color(0xFF6C63FF),
        ),
        _ScheduleClass(
          name: 'Database Systems',
          code: 'CS 305',
          instructor: 'Prof. John Chen',
          location: 'Lab B-105',
          startTime: '11:00',
          endTime: '12:30',
          duration: '1h 30m',
          type: 'LAB',
          color: const Color(0xFF06B6D4),
        ),
        _ScheduleClass(
          name: 'Software Engineering',
          code: 'CS 310',
          instructor: 'Dr. Emily Davis',
          location: 'Hall C-302',
          startTime: '14:00',
          endTime: '15:30',
          duration: '1h 30m',
          type: 'LECTURE',
          color: const Color(0xFFF472B6),
        ),
      ],
      1: [
        // Tuesday
        _ScheduleClass(
          name: 'Computer Networks',
          code: 'CS 320',
          instructor: 'Dr. Michael Brown',
          location: 'Hall D-101',
          startTime: '10:00',
          endTime: '11:30',
          duration: '1h 30m',
          type: 'LECTURE',
          color: const Color(0xFF34D399),
        ),
        _ScheduleClass(
          name: 'Human Computer Interaction',
          code: 'CS 350',
          instructor: 'Prof. Lisa Wang',
          location: 'Lab A-202',
          startTime: '14:00',
          endTime: '16:00',
          duration: '2h',
          type: 'TUTORIAL',
          color: const Color(0xFFFBBF24),
        ),
      ],
      2: [
        // Wednesday
        _ScheduleClass(
          name: 'Data Structures & Algorithms',
          code: 'CS 301',
          instructor: 'Dr. Sarah Mitchell',
          location: 'Lab C-301',
          startTime: '09:00',
          endTime: '11:00',
          duration: '2h',
          type: 'LAB',
          color: const Color(0xFF6C63FF),
        ),
        _ScheduleClass(
          name: 'Operating Systems',
          code: 'CS 315',
          instructor: 'Dr. Robert Taylor',
          location: 'Hall B-205',
          startTime: '13:00',
          endTime: '14:30',
          duration: '1h 30m',
          type: 'LECTURE',
          color: const Color(0xFFFF6B6B),
        ),
      ],
      3: [
        // Thursday
        _ScheduleClass(
          name: 'Database Systems',
          code: 'CS 305',
          instructor: 'Prof. John Chen',
          location: 'Hall A-101',
          startTime: '09:00',
          endTime: '10:30',
          duration: '1h 30m',
          type: 'LECTURE',
          color: const Color(0xFF06B6D4),
        ),
        _ScheduleClass(
          name: 'Software Engineering',
          code: 'CS 310',
          instructor: 'Dr. Emily Davis',
          location: 'Lab D-202',
          startTime: '11:00',
          endTime: '13:00',
          duration: '2h',
          type: 'LAB',
          color: const Color(0xFFF472B6),
        ),
        _ScheduleClass(
          name: 'Computer Networks',
          code: 'CS 320',
          instructor: 'Dr. Michael Brown',
          location: 'Hall D-101',
          startTime: '15:00',
          endTime: '16:30',
          duration: '1h 30m',
          type: 'TUTORIAL',
          color: const Color(0xFF34D399),
        ),
      ],
      4: [
        // Friday
        _ScheduleClass(
          name: 'Operating Systems',
          code: 'CS 315',
          instructor: 'Dr. Robert Taylor',
          location: 'Lab B-105',
          startTime: '10:00',
          endTime: '12:00',
          duration: '2h',
          type: 'LAB',
          color: const Color(0xFFFF6B6B),
        ),
        _ScheduleClass(
          name: 'Human Computer Interaction',
          code: 'CS 350',
          instructor: 'Prof. Lisa Wang',
          location: 'Hall A-201',
          startTime: '14:00',
          endTime: '15:30',
          duration: '1h 30m',
          type: 'LECTURE',
          color: const Color(0xFFFBBF24),
        ),
      ],
      5: <_ScheduleClass>[], // Saturday - no classes
    };

    return allClasses[dayIndex] ?? <_ScheduleClass>[];
  }
}

class _ScheduleClass {
  final String name;
  final String code;
  final String instructor;
  final String location;
  final String startTime;
  final String endTime;
  final String duration;
  final String type;
  final Color color;

  _ScheduleClass({
    required this.name,
    required this.code,
    required this.instructor,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.type,
    required this.color,
  });
}
