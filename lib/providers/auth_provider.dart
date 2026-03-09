import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

/// Manages authentication state across the entire app.
///
/// Exposes the current user, login/logout actions, and
/// role-based access control helpers.
///
/// Currently uses mock auth (any non-empty credentials succeed).
/// Replace the login/signup bodies with Firebase Auth calls when ready.
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  // ── Getters ──────────────────────────────────────────────────

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  String get userId => _currentUser?.uid ?? 'mock_user';

  // ── Actions ──────────────────────────────────────────────────

  /// Simulates login. Accepts any non-empty email/password.
  /// Creates a mock student user by default.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (email.isEmpty || password.isEmpty) {
        _error = 'Please fill in all fields.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Mock: admin users get admin role based on email pattern
      final role =
          email.contains('admin') ? UserRole.clubAdmin : UserRole.student;

      _currentUser = UserModel(
        uid: 'mock_user',
        name: _nameFromEmail(email),
        email: email,
        role: role,
        clubIds: role == UserRole.clubAdmin ? ['club_dsc'] : [],
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Simulates signup.
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _error = 'Please fill in all fields.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = UserModel(
        uid: 'mock_user',
        name: name,
        email: email,
        role: UserRole.student,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Signup failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logs out and clears user state.
  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  /// Clears any pending error.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Derives a display name from an email address.
  String _nameFromEmail(String email) {
    final localPart = email.split('@').first;
    return localPart
        .split(RegExp(r'[._]'))
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1)}'
            : '')
        .join(' ');
  }
}
