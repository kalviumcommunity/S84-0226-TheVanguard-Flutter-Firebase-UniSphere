import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unisphere/app/theme.dart';
import 'package:unisphere/main.dart';
import 'package:unisphere/providers/auth_provider.dart';

/// Student profile screen with academic info and account settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          _buildProfileHeader(context, theme, isDark),

          // Academic Stats
          SliverToBoxAdapter(
            child: _buildAcademicStats(theme, isDark),
          ),

          // Menu Items
          SliverToBoxAdapter(
            child: _buildMenuSection(context, theme, isDark),
          ),

          // Logout Button
          SliverToBoxAdapter(
            child: _buildLogoutSection(context, theme, isDark),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, ThemeData theme, bool isDark) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: isDark
          ? UniSphereTheme.surfaceDark
          : UniSphereTheme.surfaceLight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                UniSphereTheme.primaryColor,
                UniSphereTheme.primaryDark,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withAlpha(80),
                      width: 3,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      'AJ',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: UniSphereTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'alex.johnson@university.edu',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.badge_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Student ID: CS2021-0847',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          color: Colors.white,
          onPressed: () {
            // Edit profile
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          color: Colors.white,
          onPressed: () {
            // Settings
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAcademicStats(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(40)
                : UniSphereTheme.primaryColor.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.school_rounded,
                color: UniSphereTheme.primaryColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Academic Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme,
                  label: 'CGPA',
                  value: '3.75',
                  subtext: '/4.0',
                  icon: Icons.grade_rounded,
                  color: const Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  theme,
                  label: 'Credits',
                  value: '96',
                  subtext: '/120',
                  icon: Icons.view_module_rounded,
                  color: const Color(0xFF06B6D4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  theme,
                  label: 'Semester',
                  value: '6',
                  subtext: 'th',
                  icon: Icons.calendar_today_rounded,
                  color: const Color(0xFF34D399),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Degree Progress',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '80%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: UniSphereTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.8,
                  minHeight: 10,
                  backgroundColor: isDark
                      ? Colors.white.withAlpha(20)
                      : UniSphereTheme.primaryColor.withAlpha(30),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    UniSphereTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme, {
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                subtext,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            subtitle: 'View and edit your details',
            onTap: () {},
          ),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.description_outlined,
            title: 'Academic Records',
            subtitle: 'Transcripts & certificates',
            onTap: () {},
          ),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.payments_outlined,
            title: 'Fee Payment',
            subtitle: 'View dues & payment history',
            onTap: () {},
          ),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.credit_card_rounded,
            title: 'ID Card',
            subtitle: 'Digital student ID',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          Text(
            'Preferences',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchMenuItem(
            context,
            theme,
            isDark,
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Toggle dark theme',
          ),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {},
          ),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: () {},
          ),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'FAQs & contact support',
            onTap: () {},
          ),
          _buildMenuItem(
            theme,
            isDark,
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: 'App version 2.1.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: UniSphereTheme.primaryColor.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: UniSphereTheme.primaryColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall,
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: theme.textTheme.bodyMedium?.color?.withAlpha(100),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildSwitchMenuItem(
    BuildContext context,
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: UniSphereTheme.primaryColor.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: UniSphereTheme.primaryColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall,
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (value) {
            UniSphereApp.of(context)?.toggleTheme();
          },
          activeTrackColor: UniSphereTheme.primaryColor.withAlpha(150),
          thumbColor: WidgetStatePropertyAll(
            isDark ? UniSphereTheme.primaryColor : Colors.grey,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            // Show logout confirmation
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final auth = context.read<AuthProvider>();
                      await auth.logout();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/landing',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UniSphereTheme.error,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout_rounded, color: UniSphereTheme.error),
          label: const Text(
            'Logout',
            style: TextStyle(color: UniSphereTheme.error),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: UniSphereTheme.error),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
