# UniSphere – Flutter Widget Tree & Reactive UI Demo

**Sprint 2 – Introduction to Flutter & Dart**

A production-quality Flutter application demonstrating responsive UI design and Flutter's reactive UI model. The project includes a responsive layout that adapts between phone and tablet form factors, as well as a dedicated demo screen that illustrates the Widget Tree structure and state management with `setState()`.

---

## Folder Structure

```
lib/
├── main.dart                        # App entry point (StatelessWidget)
├── screens/
│   ├── welcome_screen.dart          # Welcome screen (StatefulWidget)
│   ├── responsive_home.dart         # Responsive home screen (StatefulWidget)
│   ├── widget_tree_demo.dart        # Widget Tree & Reactive UI demo (StatefulWidget)
│   └── stateless_stateful_demo.dart # Stateless vs Stateful widget demo
└── widgets/                         # Reusable widgets (reserved for future sprints)
```

| Path | Purpose |
|------|---------||
| `lib/main.dart` | Configures `MaterialApp`, disables the debug banner, and sets `ResponsiveHome` as the home route. |
| `lib/screens/welcome_screen.dart` | A `StatefulWidget` that toggles button text on press using `setState`. |
| `lib/screens/responsive_home.dart` | Responsive layout — single-column on phones, two-column `GridView` on tablets. |
| `lib/screens/widget_tree_demo.dart` | Demonstrates the Widget Tree hierarchy and Flutter's reactive UI model with a counter. |
| `lib/screens/stateless_stateful_demo.dart` | Combines a `StatelessWidget` header and a `StatefulWidget` counter to contrast static and reactive UI. |
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

## Responsiveness Implementation

### MediaQuery Usage

`MediaQuery` reads global device metrics to derive a breakpoint:

```dart
@override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  bool isTablet = screenWidth > 600;
  // ...
}
```

- **Phone (≤ 600 px)** — single-column card list, font size ~16, compact padding.
- **Tablet (> 600 px)** — two-column `GridView` with `crossAxisCount: 2`, font size ~22, generous padding.

### LayoutBuilder Usage

`LayoutBuilder` provides parent constraints so card widths and grid dimensions are calculated proportionally:

```dart
Widget buildMainContent({ ... }) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (isTablet) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) => buildFeatureCard(...),
        );
      }
      return SingleChildScrollView(
        child: Column(children: [ /* single-column cards */ ]),
      );
    },
  );
}
```

### Mandatory Widgets Checklist

| Widget | Where Used |
|--------|-----------|
| `MediaQuery` | `build()` — reads `screenWidth`, `screenHeight` |
| `LayoutBuilder` | `buildMainContent()` — supplies parent constraints |
| `GridView` | Tablet path — two-column card grid |
| `Wrap` | Phone path — single-column card layout |
| `AspectRatio` | `buildFeatureCard()` — consistent card proportions |
| `FittedBox` | Section title, card title, footer button text |
| `Expanded` | Card text column, main content area |
| `Flexible` | Card icon, card description text |

---

## Screenshots

<!-- Replace with actual screenshots after running the app -->

| Device | Orientation | Screenshot |
|--------|-------------|------------|
| Pixel 6 | Portrait | ![Pixel 6 Portrait](screenshots/pixel6_portrait.png) |
| Pixel 6 | Landscape | ![Pixel 6 Landscape](screenshots/pixel6_landscape.png) |
| Tablet | Portrait | ![Tablet Portrait](screenshots/tablet_portrait.png) |
| Tablet | Landscape | ![Tablet Landscape](screenshots/tablet_landscape.png) |

---

## Reflection

### Challenges Faced

- **Preventing RenderFlex overflow** — Cards inside a `Column` caused overflow in landscape mode. Wrapping the content area with `Expanded` and using `Flexible` inside cards resolved this without fixed heights.
- **Choosing between GridView and Wrap** — `GridView` handles the two-column tablet layout naturally with `crossAxisCount`, but it conflicts with nested scrolling inside a `Column`. Using `GridView` as the direct child of `Expanded` (tablet path) and `SingleChildScrollView` with `Wrap` (phone path) avoids nested scroll conflicts entirely.
- **Text scaling across form factors** — Hard-coded font sizes clip on narrow devices. `FittedBox` with `BoxFit.scaleDown` ensures text never overflows while keeping it as large as space allows.

### How Responsiveness Improves Usability

Responsive design ensures the same codebase delivers a comfortable experience on every screen size. Phone users see a focused single-column flow that's easy to scan with one hand, while tablet users benefit from a two-column grid that fills the larger viewport without wasted space. Dynamic padding and font scaling maintain visual hierarchy regardless of device dimensions or orientation, reducing cognitive load and preventing the layout-break issues that drive users away.

---

## Widget Tree & Reactive UI Demo

The `WidgetTreeDemo` screen (`lib/screens/widget_tree_demo.dart`) is a self-contained demo that showcases two core Flutter concepts:

1. **Widget Tree structure** — how widgets nest to form the UI.
2. **Reactive UI model** — how `setState()` triggers efficient rebuilds.

### Widget Tree Hierarchy

```
MaterialApp
└── Scaffold
    ├── AppBar
    │     └── Text ("Widget Tree Demo")
    └── Body
        └── Center
            └── Column
                ├── CircleAvatar (profile image placeholder)
                ├── Text ("UniSphere Counter")
                ├── Text (counter display — rebuilds on state change)
                └── ElevatedButton ("Increment Counter")
```

### Demo Screenshots

| State | Screenshot |
|-------|------------|
| Initial UI (counter = 0) | ![Initial State](screenshots/widget_tree_initial.png) |
| After button press (counter incremented) | ![Updated State](screenshots/widget_tree_updated.png) |

### What Is a Widget Tree?

In Flutter every UI element is a **widget**, and widgets compose into a tree. The root widget (e.g., `MaterialApp`) contains child widgets (`Scaffold`, `AppBar`, `Column`, …), and each child can contain further children. This tree is the single source of truth for what appears on screen. Flutter walks the tree to build the corresponding **Element** tree and **RenderObject** tree that handle layout and painting.

### How Does Flutter's Reactive Model Work?

Flutter follows a **declarative** UI paradigm:

1. State is stored inside a `State` object (e.g., `_counter`).
2. When the user interacts with the app (button press), the handler calls `setState()`.
3. `setState()` marks the enclosing `State` object as *dirty*.
4. On the next frame, Flutter calls `build()` again, producing a new widget description.
5. Flutter diffs the new tree against the old tree and applies only the minimal changes to the render layer.

```dart
void _incrementCounter() {
  setState(() {
    _counter++;
  });
}
```

### Why Does Flutter Rebuild Only Affected Widgets?

Flutter uses an **Element reconciliation** algorithm similar to React's virtual DOM diffing:

- When `setState()` is called, only the `State` object's `build()` method is re-executed — not the entire app.
- Flutter compares the new widget tree with the previous one element by element.
- Widgets whose configuration has **not** changed (same type and key) are skipped; their existing render objects are reused.
- Only widgets with **new data** (e.g., the `Text` widget showing the counter value) are updated in the render tree.

This selective rebuilding keeps frame times low and makes Flutter performant even with complex UIs.

---

## Stateless vs Stateful Widgets Demo

The `StatelessStatefulDemo` screen (`lib/screens/stateless_stateful_demo.dart`) pairs a **StatelessWidget** and a **StatefulWidget** side-by-side to highlight their differences.

### Screen Structure

```
Scaffold
┣ AppBar (title: "Widget Types Demo")
┗ Body
  ┗ Column (centered)
    ┣ DemoHeader          ← StatelessWidget
    ┣ SizedBox (spacing)
    ┗ InteractiveCounter   ← StatefulWidget
```

### What Is a StatelessWidget?

A `StatelessWidget` describes part of the UI that depends **only** on its constructor arguments. Once built, its output never changes — it has no mutable fields and no `setState()`. Use it for labels, icons, static layouts, and any element whose appearance is fixed for its lifetime.

```dart
class DemoHeader extends StatelessWidget {
  const DemoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Stateless vs Stateful Demo',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }
}
```

### What Is a StatefulWidget?

A `StatefulWidget` owns a companion `State` object that can hold **mutable** data. When that data changes, calling `setState()` tells Flutter to re-run `build()`, updating only the affected part of the widget tree. Use it whenever the UI must react to user input, animations, or asynchronous events.

```dart
class InteractiveCounter extends StatefulWidget {
  const InteractiveCounter({super.key});

  @override
  State<InteractiveCounter> createState() => _InteractiveCounterState();
}

class _InteractiveCounterState extends State<InteractiveCounter> {
  int _counter = 0;

  void _increase() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Count: $_counter', style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _increase,
          child: const Text('Increase'),
        ),
      ],
    );
  }
}
```

### When to Use Each?

| Criterion | StatelessWidget | StatefulWidget |
|-----------|----------------|----------------|
| Mutable data | None | Yes — stored in `State` |
| Rebuilds on interaction | No | Yes — via `setState()` |
| Typical use cases | Titles, icons, static cards | Forms, counters, toggles, animations |
| Performance | Lightest — never rebuilds itself | Rebuilds only when `setState()` is called |

### Demo Screenshots

| State | Screenshot |
|-------|------------|
| Initial UI (count = 0) | ![Initial State](screenshots/stateless_stateful_initial.png) |
| After button clicks (count incremented) | ![Updated State](screenshots/stateless_stateful_updated.png) |

### Reflection

**How Stateful widgets make apps dynamic** — Without mutable state, every screen would be a static poster. `StatefulWidget` lets the app remember user actions (taps, text input, scroll position) and respond instantly by re-rendering only the widgets whose data changed. This is the foundation of every interactive Flutter experience — from a simple counter to complex forms and real-time feeds.

**Why separating static and reactive UI improves maintainability** — Marking a widget as `StatelessWidget` signals to both Flutter and future developers that it carries no side-effects and never triggers rebuilds on its own. This makes the codebase easier to reason about: `StatelessWidget`s can be safely reused, tested in isolation, and moved around without worrying about hidden state. Keeping state concentrated in clearly-identified `StatefulWidget`s reduces bugs and makes performance profiling straightforward — you know exactly which widgets can change and why.

---

## Tech Stack

### Frontend
- Flutter
- Dart

### Backend (planned)
- Firebase Authentication
- Cloud Firestore
- Firebase Storage