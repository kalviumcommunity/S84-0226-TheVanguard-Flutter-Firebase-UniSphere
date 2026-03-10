import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/main_shell.dart';
import '../screens/event_details_screen.dart';
import '../screens/admin/create_event_screen.dart';
import '../screens/admin/create_announcement_screen.dart';

/// Centralized route configuration for the entire app.
///
/// Extracted from main.dart so that route table, transition logic,
/// and future role-based guards live in one place.
class AppRouter {
  AppRouter._();

  // ── Route names ────────────────────────────────────────────────
  static const String splash = '/';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String eventDetails = '/event-details';
  static const String createEvent = '/admin/create-event';
  static const String createAnnouncement = '/admin/create-announcement';

  /// Generates a [Route] based on [RouteSettings].
  ///
  /// Uses smooth page transitions matching the original app feel.
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case splash:
        page = const SplashScreen();
        break;
      case landing:
        page = const LandingScreen();
        break;
      case login:
        page = const LoginScreen();
        break;
      case signup:
        page = const SignupScreen();
        break;
      case dashboard:
        page = const MainShell();
        break;
      case eventDetails:
        // Slide-up + fade for details overlay feel
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, a1, a2) => const EventDetailsScreen(),
          transitionsBuilder: (context, animation, a2, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.25),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      case createEvent:
        page = const CreateEventScreen();
        break;
      case createAnnouncement:
        page = const CreateAnnouncementScreen();
        break;
      default:
        page = const LandingScreen();
    }

    // Default fade transition for all other routes
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, a1, a2) => page,
      transitionsBuilder: (context, animation, a2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
