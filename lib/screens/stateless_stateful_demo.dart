import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────
// StatelessWidget – displays a static, unchanging header.
// ─────────────────────────────────────────────────────────────────

/// A purely static header that never changes after it is built.
/// Because it holds no mutable state, it extends [StatelessWidget].
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

// ─────────────────────────────────────────────────────────────────
// StatefulWidget – manages a counter that updates on button press.
// ─────────────────────────────────────────────────────────────────

/// An interactive counter widget that tracks and displays a count.
/// Because it owns mutable state ([_counter]), it extends [StatefulWidget].
class InteractiveCounter extends StatefulWidget {
  const InteractiveCounter({super.key});

  @override
  State<InteractiveCounter> createState() => _InteractiveCounterState();
}

class _InteractiveCounterState extends State<InteractiveCounter> {
  /// The counter value managed by this widget's state.
  int _counter = 0;

  /// Increments [_counter] and calls [setState] so Flutter
  /// rebuilds only the widgets that depend on the updated value.
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
        Text(
          'Count: $_counter',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _increase,
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
            'Increase',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Parent screen – combines both widgets in a single view.
// ─────────────────────────────────────────────────────────────────

/// The entry-point screen that composes [DemoHeader] (Stateless) and
/// [InteractiveCounter] (Stateful) inside a [Scaffold].
///
/// Widget tree:
/// ```
/// Scaffold
/// ┣ AppBar (title: "Widget Types Demo")
/// ┗ Body
///   ┗ Column (centered)
///     ┣ DemoHeader   (StatelessWidget)
///     ┣ SizedBox     (spacing)
///     ┗ InteractiveCounter (StatefulWidget)
/// ```
class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Types Demo'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DemoHeader(),
            SizedBox(height: 32),
            InteractiveCounter(),
          ],
        ),
      ),
    );
  }
}
