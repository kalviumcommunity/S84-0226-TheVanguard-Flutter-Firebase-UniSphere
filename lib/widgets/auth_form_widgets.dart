import 'package:flutter/material.dart';

/// Shared auth page header used by login/signup screens.
class AuthFormHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthFormHeader({
    required this.title, required this.subtitle, super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Shared password input with visibility toggle.
class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String>? onSubmitted;

  const AuthPasswordField({
    required this.controller, required this.obscureText, required this.onToggleVisibility, super.key,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}

/// Shared loading button for auth submit actions.
class AuthLoadingButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final VoidCallback onPressed;

  const AuthLoadingButton({
    required this.isLoading, required this.label, required this.onPressed, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}

/// Shared auth redirect row (e.g., Login <-> Sign Up links).
class AuthRedirectRow extends StatelessWidget {
  final String prompt;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthRedirectRow({
    required this.prompt, required this.actionLabel, required this.onTap, super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prompt, style: theme.textTheme.bodyMedium),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
