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

## Hot Reload, Debug Console & DevTools Demonstration

This section documents how Flutter's development tools — **Hot Reload**, the **Debug Console**, and **Flutter DevTools** — were used during Sprint 2 development. All demonstrations are based on the existing `WidgetTreeDemo` screen ([lib/screens/widget_tree_demo.dart](lib/screens/widget_tree_demo.dart)).

### What Is Hot Reload?

Hot Reload injects updated source code into the running Dart VM and rebuilds the widget tree — **without** restarting the app or losing in-memory state. It typically completes in under one second, enabling a rapid edit-save-see cycle.

### What Is the Debug Console?

The Debug Console (VS Code: **Ctrl+Shift+Y**) displays runtime output from `debugPrint()` and framework messages. Unlike `print()`, `debugPrint()` throttles output to avoid dropped lines on slower devices, making it the recommended logging function during development.

### What Is Flutter DevTools?

Flutter DevTools is a browser-based suite of profiling and debugging tools that ships with the Flutter SDK. It includes a Widget Inspector, Performance overlay, Memory profiler, Network monitor, and more.

---

### Steps Performed

#### 1. Hot Reload

1. Ran the app with `flutter run -d chrome`.
2. Opened `lib/screens/widget_tree_demo.dart`.
3. Changed the subtitle text from `'Hot Reload Active'` to a new string (e.g., `'Hot Reload Working!'`).
4. Pressed **Save** (Ctrl+S).
5. The running app updated the text **instantly** — the counter value was preserved because Hot Reload does not reset state.

**Code location (editable label for Hot Reload demo):**

```dart
// Hot Reload demo label — edit the string below, press Save,
// and the running app updates instantly without losing state.
const Text(
  'Hot Reload Active',   // ← change this text and save
  style: TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.italic,
    color: Colors.deepPurple,
  ),
),
```

#### 2. Debug Console

Added `debugPrint()` inside the counter increment handler so every button press logs the new count:

```dart
void _incrementCounter() {
  setState(() {
    _counter++;
  });

  // Logs to the Debug Console on each press
  debugPrint('Counter updated to $_counter');
}
```

**Console output example:**

```
flutter: Counter updated to 1
flutter: Counter updated to 2
flutter: Counter updated to 3
```

#### 3. Flutter DevTools

| Step | Action |
|------|--------|
| **Open DevTools** | While the app is running, press `Ctrl+Shift+P` in VS Code → type *"Open DevTools"* → select **Dart: Open DevTools**. Alternatively, click the DevTools icon in the status bar. |
| **Widget Inspector** | Select the **Widget Inspector** tab. Click *"Select Widget Mode"* to tap any widget in the running app and see its position in the tree, constraints, and render details. |
| **Performance tab** | Switch to the **Performance** tab. Interact with the app (press the counter button repeatedly). The frame rendering chart shows whether frames stay under the 16 ms budget (green) or exceed it (red jank frames). |
| **Memory tab** | Switch to the **Memory** tab. Observe the Dart heap size. Trigger garbage collection with the GC button. Verify that no unexpected memory growth occurs during normal use. |

---

### Demo Screenshots

| Screenshot | Description |
|------------|-------------|
| ![Hot Reload](screenshots/hot_reload_demo.png) | Running app after saving a text change — UI updated without restart |
| ![Debug Console](screenshots/debug_console_logs.png) | Debug Console showing `debugPrint` output after button presses |
| ![Widget Inspector](screenshots/devtools_widget_inspector.png) | DevTools Widget Inspector highlighting the counter `Text` widget |
| ![Performance Tab](screenshots/devtools_performance.png) | DevTools Performance tab — frame rendering timeline |

---

### Reflection

**How does Hot Reload improve productivity?**
Hot Reload eliminates the compile-restart-navigate cycle that slows traditional mobile development. Developers can tweak layouts, styles, and logic and see results in under a second — all while the app keeps its current state. This shortens the feedback loop dramatically and encourages experimentation.

**Why is Debug Console useful?**
The Debug Console provides real-time visibility into app behavior without attaching a full debugger. `debugPrint()` statements placed at key execution points confirm that logic runs in the expected order with the expected values, making it easy to catch off-by-one errors, null references, or unintended code paths early.

**How does DevTools help identify performance issues?**
The Performance tab surfaces frame-level timing so developers can spot jank (frames exceeding 16 ms) immediately. The Widget Inspector reveals unnecessary rebuilds — if a widget that should be static keeps appearing in the rebuild list, it can be refactored into a `const` constructor or extracted into a `StatelessWidget`. The Memory tab catches leaks before they reach production.

**How would these tools help in team development?**
In a team setting, Hot Reload lets UI designers and developers iterate on screens together in real time. Standardising `debugPrint()` logging with clear prefixes makes shared debugging sessions more productive. DevTools performance baselines can be committed to CI pipelines, ensuring that no pull request introduces regressions above an agreed frame-budget threshold.

---

## Tech Stack

### Frontend
- Flutter
- Dart

### Backend (planned)
- Firebase Authentication
- Cloud Firestore
- Firebase Storage