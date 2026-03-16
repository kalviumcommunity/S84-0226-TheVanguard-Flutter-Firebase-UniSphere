import 'package:unisphere/models/registration_model.dart';
import 'package:unisphere/repositories/registration_repository.dart';

/// Mock implementation of [RegistrationRepository] using in-memory data.
class MockRegistrationRepository implements RegistrationRepository {
  final Map<String, RegistrationModel> _registrations = {};
  int _idCounter = 0;

  /// Pre-seed: user is registered for events 0 and 1 (matching original behavior).
  MockRegistrationRepository() {
    const userId = 'mock_user';
    _registrations['${userId}_0'] = RegistrationModel(
      id: 'reg_0',
      userId: userId,
      eventId: '0',
      registeredAt: DateTime(2026, 2, 25),
    );
    _registrations['${userId}_1'] = RegistrationModel(
      id: 'reg_1',
      userId: userId,
      eventId: '1',
      registeredAt: DateTime(2026, 2, 26),
    );
    _idCounter = 2;
  }

  String _key(String userId, String eventId) => '${userId}_$eventId';

  @override
  Future<List<RegistrationModel>> getUserRegistrations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _registrations.values
        .where((r) =>
            r.userId == userId && r.status != RegistrationStatus.cancelled)
        .toList();
  }

  @override
  Future<List<RegistrationModel>> getEventRegistrations(
      String eventId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _registrations.values
        .where((r) =>
            r.eventId == eventId && r.status != RegistrationStatus.cancelled)
        .toList();
  }

  @override
  Future<RegistrationModel> register(String userId, String eventId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final key = _key(userId, eventId);
    final existing = _registrations[key];
    if (existing != null && existing.status != RegistrationStatus.cancelled) {
      return existing; // Already registered
    }
    final reg = RegistrationModel(
      id: 'reg_${_idCounter++}',
      userId: userId,
      eventId: eventId,
      registeredAt: DateTime.now(),
    );
    _registrations[key] = reg;
    return reg;
  }

  @override
  Future<void> cancelRegistration(String registrationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final entry = _registrations.entries
        .where((e) => e.value.id == registrationId)
        .firstOrNull;
    if (entry != null) {
      _registrations[entry.key] = entry.value.copyWith(
        status: RegistrationStatus.cancelled,
        cancelledAt: DateTime.now(),
      );
    }
  }

  @override
  Future<RegistrationStatus?> getRegistrationStatus(
      String userId, String eventId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final reg = _registrations[_key(userId, eventId)];
    return reg?.status;
  }
}
