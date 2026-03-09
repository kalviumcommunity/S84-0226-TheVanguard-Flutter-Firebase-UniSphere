import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'announcements_screen.dart';
import 'attendance_screen.dart';

/// The main shell screen that wraps the Dashboard, Announcements,
/// and Attendance tabs inside a BottomNavigationBar.
///
/// Maintains tab state using [IndexedStack] so each tab preserves
/// its scroll position and local state.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // All three tab pages — using IndexedStack preserves state.
  final List<Widget> _pages = const [
    DashboardScreen(),
    AnnouncementsScreen(),
    AttendanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              activeIcon: Icon(Icons.campaign_rounded),
              label: 'Announcements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_reg_outlined),
              activeIcon: Icon(Icons.how_to_reg_rounded),
              label: 'Attendance',
            ),
          ],
        ),
      ),
    );
  }
}
