# UniSphere Project Overview

## Purpose
UniSphere is a Flutter app for campus life management, including authentication, announcements, events, attendance, and student-facing utilities.

## Current Scope
- Firebase authentication (signup, login, logout)
- Session-aware routing using auth state listeners
- Dashboard and profile flows
- Announcements and events modules
- Attendance and registration data handling
- Multi-platform Flutter support (Android, iOS, Web, Windows, Linux, macOS)

## Tech Stack
- Flutter + Dart
- Firebase Auth
- Firestore
- Provider-based state management

## Quick Start
1. Verify toolchain:
   ```bash
   flutter doctor
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run app:
   ```bash
   flutter run -d chrome
   ```

## Key Directories
- `lib/`: Application source code
- `lib/models/`: Data models
- `lib/providers/`: State providers
- `lib/repositories/`: Data access layer
- `lib/screens/`: UI screens
- `docs/`: Setup and process documentation
- `test/`: Test files

## Important Docs
- `README.md`: Full project readme and feature notes
- `FIREBASE_README.md`: Firebase-specific setup and auth flow notes
- `docs/FIREBASE_SETUP.md`: Detailed Firebase setup steps
- `ARCHITECTURE.md`: High-level architecture details

## Suggested Next Updates
- Add module ownership and contributors
- Add environment matrix (dev/staging/prod)
- Add release checklist and testing checklist
