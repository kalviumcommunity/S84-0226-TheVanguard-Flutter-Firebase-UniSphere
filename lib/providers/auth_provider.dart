import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:unisphere/models/user_model.dart';
import 'package:unisphere/services/auth_service.dart';
import 'package:unisphere/services/firestore_service.dart';

/// Manages authentication state across the entire app.
///
/// Backed by Firebase Authentication + Cloud Firestore.
/// Auth session persistence is handled by Firebase and restored automatically.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? AuthService(),
        _firestoreService = firestoreService ?? FirestoreService() {
    _authSubscription = _authService.authStateChanges.listen(_onAuthStateChanged);

    final initialUser = _authService.currentUser;
    if (initialUser == null) {
      _isLoading = false;
    } else {
      _onAuthStateChanged(initialUser);
    }
  }

  final AuthService _authService;
  final FirestoreService _firestoreService;
  StreamSubscription<User?>? _authSubscription;

  UserModel? _currentUser;
  bool _isLoading = true;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  String get userId => _currentUser?.uid ?? 'guest_user';

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _error = 'Please fill in all fields.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );

      if (user == null) {
        _error = 'Login failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _syncUserProfile(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = AuthService.friendlyError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _error = 'Please fill in all fields.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
      );

      if (user == null) {
        _error = 'Signup failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await user.updateDisplayName(name.trim());
      await _syncUserProfile(user, preferredName: name.trim());

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = AuthService.friendlyError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Signup failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _error = null;
    } catch (_) {
      _error = 'Logout failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    await _syncUserProfile(firebaseUser);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _syncUserProfile(
    User firebaseUser, {
    String? preferredName,
  }) async {
    final existing = await _firestoreService.getUserData(firebaseUser.uid);

    if (existing != null) {
      _currentUser = UserModel.fromMap(existing, docId: firebaseUser.uid);
      return;
    }

    final role = firebaseUser.email?.contains('admin') ?? false
        ? UserRole.clubAdmin
        : UserRole.student;

    final displayName = firebaseUser.displayName?.trim() ?? '';
    final resolvedName = preferredName?.trim().isNotEmpty == true
        ? preferredName!.trim()
        : displayName.isNotEmpty
            ? displayName
            : _nameFromEmail(firebaseUser.email ?? '');

    final user = UserModel(
      uid: firebaseUser.uid,
      name: resolvedName,
      email: firebaseUser.email ?? '',
      role: role,
      clubIds: role == UserRole.clubAdmin ? ['club_dsc'] : const [],
    );

    await _firestoreService.addUserData(
      firebaseUser.uid,
      {
        ...user.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    _currentUser = user;
  }

  String _nameFromEmail(String email) {
    if (email.isEmpty) return 'Student';
    final localPart = email.split('@').first;
    return localPart
        .split(RegExp(r'[._]'))
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ')
        .trim();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
