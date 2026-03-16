import 'package:unisphere/models/registration_model.dart';

/// Abstract contract for registration data operations.
abstract class RegistrationRepository {
  /// Returns all registrations for a given [userId].
  Future<List<RegistrationModel>> getUserRegistrations(String userId);

  /// Returns all registrations for a given [eventId].
  Future<List<RegistrationModel>> getEventRegistrations(String eventId);

  /// Registers a user for an event.
  Future<RegistrationModel> register(String userId, String eventId);

  /// Cancels a registration.
  Future<void> cancelRegistration(String registrationId);

  /// Checks whether [userId] is registered for [eventId].
  Future<RegistrationStatus?> getRegistrationStatus(
      String userId, String eventId);
}
