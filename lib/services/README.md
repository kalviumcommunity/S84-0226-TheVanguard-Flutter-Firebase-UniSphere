# Services

This directory contains business logic and service classes.

## Purpose

Services encapsulate complex business logic and provide:
- Reusable business operations
- Integration with external services
- Complex calculations and data processing
- Orchestration between multiple repositories

## Service Structure

Services should be stateless and focus on:
- Business logic that doesn't fit in models or repositories
- Third-party API integrations
- Complex data transformations
- Coordination of multiple data sources

## Planned Services

### Authentication Service
- Token management
- Session handling
- Password reset flows
- Email verification

### Notification Service
- Push notifications
- In-app notifications
- Email notifications
- Notification preferences

### Analytics Service
- Event tracking
- User behavior analytics
- Performance monitoring
- Error reporting

### Storage Service
- File uploads
- Image processing
- Document management
- Storage quota management

## Service Pattern Example

```dart
class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  
  NotificationService(this._messaging, this._firestore);
  
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    // Business logic for sending notifications
    // 1. Get user's notification preferences
    // 2. Check if notifications are enabled
    // 3. Send via appropriate channel
    // 4. Log notification in database
  }
  
  Future<void> scheduleEventReminder(EventModel event) async {
    // Schedule notification 24h before event
  }
}
```

## Best Practices

1. **Single Responsibility**: Each service handles one domain
2. **Dependency Injection**: Inject dependencies via constructor
3. **Stateless**: Services should not maintain state
4. **Error Handling**: Throw specific, descriptive exceptions
5. **Testing**: Write comprehensive unit tests
6. **Logging**: Log important operations for debugging
7. **Async Operations**: Use async/await for all I/O operations

## Service vs Repository vs Provider

- **Repository**: Data access layer (CRUD operations)
- **Service**: Business logic layer (complex operations)
- **Provider**: State management (UI state and coordination)

Example flow:
```
UI (Widget)
  ↓
Provider (State Management)
  ↓
Service (Business Logic)
  ↓
Repository (Data Access)
  ↓
Firebase/API (Data Source)
```

## Error Handling

Define custom exceptions for services:

```dart
class ServiceException implements Exception {
  final String message;
  final String code;
  
  ServiceException(this.message, this.code);
  
  @override
  String toString() => 'ServiceException: $message (code: $code)';
}
```

## Testing

Services should have comprehensive unit tests:

```dart
void main() {
  late NotificationService service;
  late MockFirebaseMessaging mockMessaging;
  
  setUp(() {
    mockMessaging = MockFirebaseMessaging();
    service = NotificationService(mockMessaging);
  });
  
  test('sendNotification sends message', () async {
    await service.sendNotification(
      userId: 'user123',
      title: 'Test',
      body: 'Test body',
    );
    
    verify(mockMessaging.send(any)).called(1);
  });
}
```

## Future Additions

As the application grows, consider adding:
- Caching service
- Search service
- Export/import service
- Backup service
- Sync service
