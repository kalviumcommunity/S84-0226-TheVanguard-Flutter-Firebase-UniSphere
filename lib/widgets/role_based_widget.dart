import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';

/// A widget that conditionally renders its [child] based on the
/// current user's role.
///
/// Usage:
/// ```dart
/// RoleBasedWidget(
///   allowedRoles: [UserRole.clubAdmin, UserRole.superAdmin],
///   child: FloatingActionButton(...),
///   fallback: SizedBox.shrink(), // optional
/// )
/// ```
class RoleBasedWidget extends StatelessWidget {
  final List<UserRole> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleBasedWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.currentUser?.role ?? UserRole.student;

    if (allowedRoles.contains(role)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}
