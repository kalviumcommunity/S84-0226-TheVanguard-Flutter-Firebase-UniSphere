import 'package:flutter/material.dart';

import 'package:unisphere/app/theme.dart';
import 'package:unisphere/screens/student_home_screen.dart';
import 'package:unisphere/screens/schedule_screen.dart';
import 'package:unisphere/screens/dashboard_screen.dart';
import 'package:unisphere/screens/campus_services_screen.dart';
import 'package:unisphere/screens/profile_screen.dart';

/// The main shell screen with a modern bottom navigation bar.
/// Wraps all main screens: Home, Schedule, Events, Services, Profile.
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

  // All tab pages — using IndexedStack preserves state.
  final List<Widget> _pages = const [
    StudentHomeScreen(),
    ScheduleScreen(),
    DashboardScreen(),
    CampusServicesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark
              ? UniSphereTheme.cardColorDark
              : UniSphereTheme.cardColorLight,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(40)
                  : UniSphereTheme.primaryColor.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today_rounded,
                  label: 'Schedule',
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.event_outlined,
                  activeIcon: Icons.event_rounded,
                  label: 'Events',
                  isDark: isDark,
                  isCenter: true,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.grid_view_outlined,
                  activeIcon: Icons.grid_view_rounded,
                  label: 'Services',
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDark,
    bool isCenter = false,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    UniSphereTheme.primaryColor.withAlpha(isCenter ? 255 : 30),
                    UniSphereTheme.primaryDark.withAlpha(isCenter ? 255 : 30),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(isCenter ? 16 : 12),
          boxShadow: isSelected && isCenter
              ? [
                  BoxShadow(
                    color: UniSphereTheme.primaryColor.withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? (isCenter ? Colors.white : UniSphereTheme.primaryColor)
                  : (isDark ? Colors.white60 : Colors.grey),
              size: isCenter && isSelected ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (isCenter ? Colors.white : UniSphereTheme.primaryColor)
                    : (isDark ? Colors.white60 : Colors.grey),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
