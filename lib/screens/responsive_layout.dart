import 'package:flutter/material.dart';

/// A demo screen that showcases responsive layouts using
/// [Row], [Column], [Container], [Expanded], and [MediaQuery].
///
/// - **Narrow (< 600 px):** header on top, content stacked vertically.
/// - **Wide (≥ 600 px):** header on top, two side-by-side panels.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Layout'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ── Header Container ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Header Section',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Content Area ─────────────────────────────────
            Expanded(
              child: isWide
                  ? _buildWideLayout()
                  : _buildNarrowLayout(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Narrow layout (< 600 px): panels stacked vertically ──

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        Expanded(child: _panelA()),
        const SizedBox(height: 16),
        Expanded(child: _panelB()),
      ],
    );
  }

  // ── Wide layout (≥ 600 px): panels side by side ───────────

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(child: _panelA()),
        const SizedBox(width: 16),
        Expanded(child: _panelB()),
      ],
    );
  }

  // ── Reusable panel widgets ────────────────────────────────

  Widget _panelA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: const Center(
        child: Text(
          'Panel A',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _panelB() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: const Center(
        child: Text(
          'Panel B',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
