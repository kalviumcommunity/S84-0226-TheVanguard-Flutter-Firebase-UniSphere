import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:unisphere/app/theme.dart';

/// Animated splash screen displayed at app launch.
/// Shows the UniSphere branding with smooth animations
/// before transitioning to the landing screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeOutController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Fade out controller
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Logo animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text animations
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Fade out animation
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeOutController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimationSequence() async {
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Wait and then navigate
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      _fadeOutController.forward().then((_) {
        if (mounted) {
          final isSignedIn = FirebaseAuth.instance.currentUser != null;
          final nextRoute = isSignedIn ? '/dashboard' : '/landing';
          Navigator.pushReplacementNamed(context, nextRoute);
        }
      });
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _textController,
          _fadeOutController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeOut,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0D1117),
                          const Color(0xFF161B22),
                          const Color(0xFF1A1F2E),
                        ]
                      : [
                          const Color(0xFFF5F7FF),
                          const Color(0xFFEEF1FF),
                          const Color(0xFFE8ECFF),
                        ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // ── Animated Logo ──
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: _buildLogo(isDark),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── App Name ──
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: _buildAppName(isDark),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Tagline ──
                    FadeTransition(
                      opacity: _taglineOpacity,
                      child: _buildTagline(isDark),
                    ),

                    const Spacer(flex: 2),

                    // ── Loading indicator ──
                    FadeTransition(
                      opacity: _textOpacity,
                      child: _buildLoadingIndicator(),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            UniSphereTheme.primaryColor,
            UniSphereTheme.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: UniSphereTheme.primaryColor.withAlpha(isDark ? 80 : 100),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow effect
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  UniSphereTheme.accentCyan.withAlpha(40),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Icon
          const Icon(
            Icons.school_rounded,
            size: 56,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildAppName(bool isDark) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          UniSphereTheme.primaryColor,
          UniSphereTheme.accentCyan,
        ],
      ).createShader(bounds),
      child: Text(
        'UniSphere',
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -1,
          shadows: [
            Shadow(
              color: UniSphereTheme.primaryColor.withAlpha(60),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagline(bool isDark) {
    return Text(
      'Centralizing campus life',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isDark
            ? Colors.white.withAlpha(180)
            : UniSphereTheme.primaryDark.withAlpha(180),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          UniSphereTheme.primaryColor.withAlpha(200),
        ),
      ),
    );
  }
}
