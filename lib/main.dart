import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:unisphere/firebase_options.dart';

import 'package:unisphere/app/theme.dart';
import 'package:unisphere/app/router.dart';
import 'package:unisphere/providers/auth_provider.dart';
import 'package:unisphere/providers/event_provider.dart';
import 'package:unisphere/providers/registration_provider.dart';
import 'package:unisphere/providers/announcement_provider.dart';
import 'package:unisphere/repositories/firebase/firebase_repositories.dart';
import 'package:unisphere/screens/auth_screen.dart';
import 'package:unisphere/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    // Create Firebase repositories
    final eventRepository = FirebaseEventRepository();
    final registrationRepository = FirebaseRegistrationRepository(
      eventRepository: eventRepository,
    );
    final announcementRepository = FirebaseAnnouncementRepository();

    return MultiProvider(
      providers: [
        // Auth state
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Event state (backed by Firebase)
        ChangeNotifierProvider(
          create: (_) => EventProvider(eventRepository),
        ),

        // Registration state (backed by Firebase)
        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(registrationRepository),
        ),

        // Announcement state (backed by Firebase)
        ChangeNotifierProvider(
          create: (_) => AnnouncementProvider(announcementRepository),
        ),
      ],
      child: MaterialApp(
        title: 'UniSphere',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: UniSphereTheme.lightTheme,
        darkTheme: UniSphereTheme.darkTheme,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasData) {
              return const HomeScreen();
            }

            return const AuthScreen();
          },
        ),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}


