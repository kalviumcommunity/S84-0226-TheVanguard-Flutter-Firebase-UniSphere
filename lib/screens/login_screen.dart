import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_form_widgets.dart';

/// A simulated login screen with email and password fields.
/// Uses AuthProvider for state management — navigates on success.
/// Uses centralized theming — no repeated style blocks.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final auth = context.read<AuthProvider>();
    final success = await auth.login(email, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Login failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 80.0 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthFormHeader(
                title: 'Welcome Back',
                subtitle: 'Sign in to continue',
              ),
              const SizedBox(height: 36),

              // ── Email field ──
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 18),

              AuthPasswordField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onSubmitted: (_) => _handleLogin(),
                onToggleVisibility: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: 28),

              // ── Login button ──
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return AuthLoadingButton(
                    isLoading: auth.isLoading,
                    label: 'Login',
                    onPressed: _handleLogin,
                  );
                },
              ),
              const SizedBox(height: 18),

              AuthRedirectRow(
                prompt: "Don't have an account? ",
                actionLabel: 'Sign Up',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
