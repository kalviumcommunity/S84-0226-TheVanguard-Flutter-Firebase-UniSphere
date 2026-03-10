# Repositories

This directory contains repository classes that handle data access and persistence.

## Purpose

Repositories provide an abstraction layer over data sources, offering:
- Clean separation between data and business logic
- Centralized data access logic
- Easy switching between data sources (Firestore, local, mock)
- Testability through dependency injection

## Current Repositories

### `event_repository.dart`
Handles all event-related data operations.

**Responsibilities:**
- Fetch events from Firestore
- Create, update, delete events
- Query events by filters (date, category, club)
- Handle event data transformations

**Key Methods:**
- `getEvents()` - Retrieve all events
- `getEventById(String id)` - Get specific event
- `createEvent(EventModel event)` - Add new event
- `updateEvent(EventModel event)` - Modify event
- `deleteEvent(String id)` - Remove event

### `announcement_repository.dart`
Manages announcement data operations.

**Responsibilities:**
- Fetch announcements from Firestore
- Post new announcements
- Update and delete announcements
- Filter announcements by club or date

**Key Methods:**
- `getAnnouncements()` - Retrieve announcements
- `getAnnouncementsByClub(String clubId)` - Filter by club
- `createAnnouncement(AnnouncementModel announcement)` - Post announcement

### `registration_repository.dart`
Handles event registration data.

**Responsibilities:**
- Manage user registrations
- Track registration status
- Handle waitlist operations
- Query user registrations

**Key Methods:**
- `registerUser(String userId, String eventId)` - Register for event
- `getUserRegistrations(String userId)` - Get user's registrations
- `cancelRegistration(String registrationId)` - Cancel registration

### `attendance_repository.dart`
Manages attendance tracking.

**Responsibilities:**
- Record attendance check-ins
- Track attendance history
- Generate attendance reports
- Verify attendance status

**Key Methods:**
- `checkIn(String userId, String eventId)` - Mark attendance
- `getAttendanceHistory(String userId)` - Get user's attendance
- `getEventAttendance(String eventId)` - Get event attendance list

## Mock Repositories

The `mock/` subdirectory contains mock implementations for testing and development:

- `mock_event_repository.dart` - Returns hardcoded event data
- Useful for UI development without backend
- Can be swapped with real repositories via dependency injection

## Repository Pattern

All repositories follow this structure:

```dart
abstract class EventRepository {
  Future<List<EventModel>> getEvents();
  Future<EventModel?> getEventById(String id);
  Future<void> createEvent(EventModel event);
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String id);
}

class FirestoreEventRepository implements EventRepository {
  final FirebaseFirestore _firestore;
  
  FirestoreEventRepository(this._firestore);
  
  @override
  Future<List<EventModel>> getEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .orderBy('date', descending: true)
        .get();
    
    return snapshot.docs
        .map((doc) => EventModel.fromJson(doc.data()))
        .toList();
  }
  
  // ... other methods
}
```

## Best Practices

1. **Interface Segregation**: Define abstract base classes for testability
2. **Error Handling**: Wrap Firebase operations in try-catch blocks
3. **Type Safety**: Return typed results, not dynamic
4. **Async/Await**: Use async/await for all Firebase operations
5. **Stream Support**: Use streams for real-time data when needed
6. **Pagination**: Implement pagination for large datasets
7. **Caching**: Consider caching strategies for performance

## Error Handling Example

```dart
Future<List<EventModel>> getEvents() async {
  try {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs
        .map((doc) => EventModel.fromJson(doc.data()))
        .toList();
  } on FirebaseException catch (e) {
    throw RepositoryException('Failed to fetch events: ${e.message}');
  } catch (e) {
    throw RepositoryException('Unexpected error: $e');
  }
}
```

## Using Streams for Real-time Data

```dart
Stream<List<EventModel>> watchEvents() {
  return _firestore
      .collection('events')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => EventModel.fromJson(doc.data()))
          .toList());
}
```

## Dependency Injection

Repositories should be injected into providers:

```dart
class EventProvider extends ChangeNotifier {
  final EventRepository _repository;
  
  EventProvider(this._repository);
  
  Future<void> fetchEvents() async {
    final events = await _repository.getEvents();
    // Update state
  }
}
```

## Testing

All repositories should have corresponding tests in `test/repositories/`.

Use mock repositories or mock Firestore for testing:

```dart
void main() {
  test('getEvents returns list of events', () async {
    final mockRepo = MockEventRepository();
    final events = await mockRepo.getEvents();
    expect(events, isA<List<EventModel>>());
  });
}
```
