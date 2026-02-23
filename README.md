# UniSphere – Building Responsive Mobile Interfaces

**Sprint 2 – Introduction to Flutter & Dart**

A beginner-friendly Flutter application demonstrating responsive UI design using `MediaQuery`, `LayoutBuilder`, `Wrap`, `AspectRatio`, `FittedBox`, `Expanded`, and `Flexible`.

---

## Folder Structure

```
lib/
├── main.dart                        # App entry point (StatelessWidget)
├── screens/
│   ├── welcome_screen.dart          # Welcome screen (StatefulWidget)
│   └── responsive_home.dart         # Responsive home screen
└── widgets/                         # Reusable widgets (reserved for future sprints)
```

| Path | Purpose |
|------|---------|
| `lib/main.dart` | Configures `MaterialApp`, disables the debug banner, and sets `ResponsiveHome` as the home route. |
| `lib/screens/welcome_screen.dart` | A `StatefulWidget` that toggles button text on press using `setState`. |
| `lib/screens/responsive_home.dart` | Responsive layout that adapts between single-column (phone) and two-column (tablet) using `MediaQuery`. |
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

<!-- Replace with actual screenshots after running the app -->
| Phone | Tablet |
|-------|--------|
| ![Phone](screenshots/phone.png) | ![Tablet](screenshots/tablet.png) |

---

## Responsiveness Explained

`ResponsiveHome` adapts its layout at runtime using `MediaQuery` to read the device dimensions and a simple boolean breakpoint:

```dart
double screenWidth = MediaQuery.of(context).size.width;
bool isTablet = screenWidth > 600;
```

- **Phone (≤ 600 px)** — single-column card list, smaller font sizes, compact padding.
- **Tablet (> 600 px)** — two-column `Wrap` layout, larger fonts, generous padding.

`LayoutBuilder` supplies parent constraints so card widths are calculated proportionally rather than hard-coded. `AspectRatio` keeps card proportions consistent across orientations, while `FittedBox` prevents text overflow. `Expanded` and `Flexible` eliminate `RenderFlex` overflow errors in both portrait and landscape.

---

## Reflection

### What I learned

**Flutter Widgets**
Flutter UIs are built entirely from widgets. `StatelessWidget` is used for static content that never changes (like `MyApp`), while `StatefulWidget` is used when the UI needs to react to user interaction (like `WelcomeScreen` and `ResponsiveHome`).

**Responsive Design with MediaQuery & LayoutBuilder**
`MediaQuery` provides global device metrics (screen width, height, padding). `LayoutBuilder` provides local parent constraints. Combining both lets the UI adapt fluidly — switching column counts, padding, and font sizes without hard-coded pixel values.

**State Management with setState**
Calling `setState` tells Flutter to re-run the `build` method, updating only the parts of the widget tree that changed.

**Dart Language Fundamentals**
Dart's `const` constructors allow Flutter to optimize widget rebuilds by reusing unchanged objects. Named parameters with `super.key` simplify boilerplate. The language's strong typing and null safety reduce runtime errors.

**Modular Project Structure**
Separating screens and widgets into dedicated folders keeps the codebase organized and scalable. Helper methods like `buildHeader()`, `buildMainContent()`, and `buildFooter()` keep the widget tree readable.

---

## Tech Stack

### Frontend
- Flutter
- Dart

### Backend (planned)
- Firebase Authentication
- Cloud Firestore
- Firebase Storage