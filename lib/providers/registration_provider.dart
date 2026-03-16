import 'package:flutter/foundation.dart';

import 'package:unisphere/models/registration_model.dart';
import 'package:unisphere/repositories/registration_repository.dart';

/// Centralized registration state shared across ALL screens.
///
/// This solves the #1 architectural bug: registering on EventDetailsScreen
/// now immediately reflects on AttendanceScreen and the DashboardScreen
/// event cards — they all watch the same provider.
class RegistrationProvider extends ChangeNotifier {
  final RegistrationRepository _repository;

  RegistrationProvider(this._repository);

  // ── State ────────────────────────────────────────────────────

  /// eventId → RegistrationStatus for the current user.
  Map<String, RegistrationStatus> _statusMap = {};
  bool _isLoading = false;
  String? _error;

  // ── Getters ──────────────────────────────────────────────────

  Map<String, RegistrationStatus> get statusMap =>
      Map.unmodifiable(_statusMap);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Whether the current user is registered for [eventId].
  bool isRegistered(String eventId) {
    final status = _statusMap[eventId];
    return status == RegistrationStatus.registered ||
        status == RegistrationStatus.checkedIn;
  }

  /// Returns the registration status for [eventId], or null if not registered.
  RegistrationStatus? statusFor(String eventId) => _statusMap[eventId];

  /// Count of events the user is actively registered for.
  int get registeredCount => _statusMap.values
      .where((s) =>
          s == RegistrationStatus.registered ||
          s == RegistrationStatus.checkedIn)
      .length;

  // ── Actions ──────────────────────────────────────────────────

  /// Loads all registrations for the given [userId].
  Future<void> loadRegistrations(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final registrations = await _repository.getUserRegistrations(userId);
      _statusMap = {
        for (final reg in registrations) reg.eventId: reg.status,
      };
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load registrations: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers the current user for [eventId].
  ///
  /// Returns true on success. Both EventDetailsScreen and AttendanceScreen
  /// will auto-update because they watch this provider.
  Future<bool> register(String userId, String eventId) async {
    try {
      // Optimistic update
      _statusMap[eventId] = RegistrationStatus.registered;
      notifyListeners();

      await _repository.register(userId, eventId);
      return true;
    } catch (e) {
      // Rollback on failure
      _statusMap.remove(eventId);
      _error = 'Registration failed: $e';
      notifyListeners();
      return false;
    }
  }

  /// Unregisters (cancels) the current user from [eventId].
  Future<bool> unregister(String userId, String eventId) async {
    final previousStatus = _statusMap[eventId];
    try {
      // Optimistic update
      _statusMap.remove(eventId);
      notifyListeners();

      // Find the registration to cancel
      final registrations = await _repository.getUserRegistrations(userId);
      final reg = registrations
          .where((r) => r.eventId == eventId)
          .firstOrNull;

      if (reg != null) {
        await _repository.cancelRegistration(reg.id);
      }
      return true;
    } catch (e) {
      // Rollback on failure
      if (previousStatus != null) {
        _statusMap[eventId] = previousStatus;
      }
      _error = 'Unregistration failed: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggles registration for [eventId].
  /// Returns the new registration state (true = registered).
  Future<bool> toggleRegistration(String userId, String eventId) async {
    if (isRegistered(eventId)) {
      await unregister(userId, eventId);
      return false;
    } else {
      await register(userId, eventId);
      return true;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
