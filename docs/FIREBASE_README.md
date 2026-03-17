# Firebase in UniSphere

This document gives a quick overview of how Firebase is used in the UniSphere Flutter app and where the Firebase-related files live in this repository.

For complete setup steps, use `docs/FIREBASE_SETUP.md`.

## Why Firebase in This Project

Firebase provides a managed backend so the app can focus on features and UI.
In UniSphere, Firebase is used for:

- User authentication and session management
- Cloud data storage for app entities (events, clubs, announcements, registrations)
- Project-level configuration and security rules

## Firebase Services Used

- Firebase Authentication
- Cloud Firestore
- Firebase project configuration (FlutterFire-generated options)

Optional services can be added later (Storage, Crashlytics, Analytics, etc.) based on product requirements.

## Firebase Files in This Repository

Core Firebase config files at root:

- `firebase.json`: Firebase CLI configuration
- `firestore.rules`: Firestore security rules
- `firestore.indexes.json`: Firestore composite indexes
- `.firebaserc`: Firebase project aliases and defaults

Flutter and platform integration files:

- `lib/firebase_options.dart`: FlutterFire-generated per-platform Firebase options
- `android/app/google-services.json`: Android Firebase config
- `ios/Runner/GoogleService-Info.plist`: iOS Firebase config

Documentation:

- `docs/FIREBASE_SETUP.md`: Full step-by-step setup guide

## Initialization in Flutter

Firebase is initialized in app startup, typically through:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

This ensures correct project configuration is loaded for each platform.

## Quick Start

1. Install dependencies:
   `flutter pub get`
2. Ensure Firebase config files are present for your target platforms.
3. If needed, regenerate FlutterFire options:
   `flutterfire configure`
4. Run the app:
   `flutter run`

## Security Notes

- Keep Firestore rules strict and role-aware before production.
- Do not expose private credentials in committed files.
- Use authenticated access patterns for protected collections.
- Validate indexes for production query patterns.

## Useful Commands

- `flutterfire configure`
- `firebase deploy --only firestore:rules`
- `firebase deploy --only firestore:indexes`

## Recommended Next Steps

- Review and harden `firestore.rules` for production use.
- Add automated checks for Firebase rule/index updates.
- Keep this document and `docs/FIREBASE_SETUP.md` in sync when setup changes.
