import 'package:unisphere/models/event_model.dart';

/// Abstract contract for event data operations.
///
/// Screens and providers depend on this interface, not on
/// any specific data source (Firestore, REST, mock).
/// Swap the implementation without touching the UI layer.
abstract class EventRepository {
  /// Returns all events, optionally filtered by [clubId] or [status].
  Future<List<EventModel>> getEvents({
    String? clubId,
    EventStatus? status,
  });

  /// Returns a single event by [id].
  Future<EventModel?> getEventById(String id);

  /// Creates a new event. Returns the created event with its assigned ID.
  Future<EventModel> createEvent(EventModel event);

  /// Updates an existing event.
  Future<void> updateEvent(EventModel event);

  /// Deletes an event by [id].
  Future<void> deleteEvent(String id);

  /// Searches events by [query] matching name or club.
  Future<List<EventModel>> searchEvents(String query);
}
