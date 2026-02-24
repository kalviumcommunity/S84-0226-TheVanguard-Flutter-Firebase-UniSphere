import 'package:firebase_auth/firebase_auth.dart';

/// Service class that wraps Firebase Authentication operations.
/// Provides sign-up, login, and logout functionality.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current logged-in user (null if not authenticated).
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes — emits whenever the user signs in or out.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign Up ──────────────────────────────────────────────────────────────

  /// Creates a new account with [email] and [password].
  ///
  /// Returns the authenticated [User] on success, or throws a
  /// [FirebaseAuthException] that the caller can handle.
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  // ── Sign In ──────────────────────────────────────────────────────────────

  /// Signs in an existing account with [email] and [password].
  ///
  /// Returns the authenticated [User] on success, or throws a
  /// [FirebaseAuthException] that the caller can handle.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  // ── Sign Out ─────────────────────────────────────────────────────────────

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Friendly error message ───────────────────────────────────────────────

  /// Converts a [FirebaseAuthException] code into a readable message.
  static String friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
