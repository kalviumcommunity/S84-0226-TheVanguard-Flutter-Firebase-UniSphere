import 'package:flutter/material.dart';

/// A demo screen that illustrates Flutter's Widget Tree structure
/// and the reactive UI model using [setState].
///
/// Widget Tree hierarchy:
/// ```
/// MaterialApp
/// └── Scaffold
///     ├── AppBar
///     └── Body
///         └── Center
///             └── Column
///                 ├── CircleAvatar (profile image placeholder)
///                 ├── Text (name / title)
///                 ├── Text (counter display)
///                 └── ElevatedButton (increment counter)
/// ```
class WidgetTreeDemo extends StatefulWidget {
  const WidgetTreeDemo({super.key});

  @override
  State<WidgetTreeDemo> createState() => _WidgetTreeDemoState();
}

class _WidgetTreeDemoState extends State<WidgetTreeDemo> {
  /// The counter value displayed on screen.
  int _counter = 0;

  /// Increments [_counter] by one and triggers a rebuild of
  /// only the widgets that depend on the changed state.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Tree Demo'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile image placeholder
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Name / title
            const Text(
              'UniSphere Counter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Counter text — this widget rebuilds when state changes
            Text(
              'Button pressed $_counter time${_counter == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Increment button
            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Increment Counter',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
