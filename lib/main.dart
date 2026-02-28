import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/theme.dart';
import 'app/router.dart';
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/registration_provider.dart';
import 'providers/announcement_provider.dart';
import 'repositories/mock/mock_event_repository.dart';
import 'repositories/mock/mock_announcement_repository.dart';
import 'repositories/mock/mock_registration_repository.dart';

void main() {
  runApp(const UniSphereApp());
}

// Root App — provides centralized theming, state, & dark-mode toggle

class UniSphereApp extends StatefulWidget {
  const UniSphereApp({super.key});

  /// Access root state from any descendant for theme toggling.
  static UniSphereAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<UniSphereAppState>();

  @override
  State<UniSphereApp> createState() => UniSphereAppState();
}

class UniSphereAppState extends State<UniSphereApp> {
  ThemeMode _themeMode = ThemeMode.light;

  /// Toggles between light and dark mode.
  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth state
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Event state (backed by mock repository)
        ChangeNotifierProvider(
          create: (_) => EventProvider(MockEventRepository()),
        ),

        // Registration state (backed by mock repository)
        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(MockRegistrationRepository()),
        ),

        // Announcement state (backed by mock repository)
        ChangeNotifierProvider(
          create: (_) => AnnouncementProvider(MockAnnouncementRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'UniSphere',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: UniSphereTheme.lightTheme,
        darkTheme: UniSphereTheme.darkTheme,
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

