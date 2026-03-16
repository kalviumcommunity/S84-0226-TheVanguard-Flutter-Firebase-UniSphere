import 'package:flutter/material.dart';

import 'package:unisphere/main.dart';

/// Reusable AppBar action for toggling light/dark mode.
class ThemeToggleAction extends StatelessWidget {
  const ThemeToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = UniSphereApp.of(context);
    final isDarkMode = appState?.isDarkMode ?? false;

    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
      ),
      tooltip: 'Toggle theme',
      onPressed: appState?.toggleTheme,
    );
  }
}
