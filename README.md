# UniSphere

**Sprint 2 – Introduction to Flutter & Dart**

A beginner-friendly Flutter application demonstrating core concepts: widget composition, stateful vs stateless widgets, and state management with `setState`.

---

## Folder Structure

```
lib/
├── main.dart                      # App entry point (StatelessWidget)
├── screens/
│   └── welcome_screen.dart        # Welcome screen (StatefulWidget)
└── widgets/                       # Reusable widgets (reserved for future sprints)
```

| Path | Purpose |
|------|---------|
| `lib/main.dart` | Configures `MaterialApp`, disables the debug banner, and sets `WelcomeScreen` as the home route. |
| `lib/screens/welcome_screen.dart` | A `StatefulWidget` that toggles button text on press using `setState`. |
| `lib/widgets/` | Empty directory scaffolded for custom reusable widgets in upcoming sprints. |

---

## Setup Instructions

### Prerequisites

- Flutter SDK installed and on your PATH
- Chrome or a Windows desktop environment for running the app

### 1. Verify your environment

```bash
flutter doctor
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
# Run on Chrome
flutter run -d chrome

# Run on Windows desktop
flutter run -d windows
```

---

## Demo

<!-- Replace with an actual screenshot after running the app -->
![App Screenshot](screenshots/demo.png)

---

## Reflection

### What I learned

**Flutter Widgets**
Flutter UIs are built entirely from widgets. `StatelessWidget` is used for static content that never changes (like `MyApp`), while `StatefulWidget` is used when the UI needs to react to user interaction (like `WelcomeScreen`).

**State Management with setState**
Calling `setState` tells Flutter to re-run the `build` method, updating only the parts of the widget tree that changed. In this sprint, a boolean `isPressed` toggles the button label between "Press Me" and "Welcome Back!" — a minimal but clear demonstration of reactive UI updates.

**Dart Language Fundamentals**
Dart's `const` constructors allow Flutter to optimize widget rebuilds by reusing unchanged objects. Named parameters with `super.key` simplify boilerplate. The language's strong typing and null safety reduce runtime errors.

**Modular Project Structure**
Separating screens and widgets into dedicated folders keeps the codebase organized and scalable. Even at this early stage, the structure is ready to accommodate new features in future sprints.

---

## Tech Stack

### Frontend
- Flutter
- Dart

### Backend (planned)
- Firebase Authentication
- Cloud Firestore
- Firebase Storage