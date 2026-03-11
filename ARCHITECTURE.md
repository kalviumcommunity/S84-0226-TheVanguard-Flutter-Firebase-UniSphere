# UniSphere Architecture Documentation

## Overview

UniSphere follows a clean, layered architecture pattern with clear separation of concerns. The application is built using Flutter and Firebase, implementing the Provider pattern for state management.

## Architecture Pattern

We follow a **Modified Clean Architecture** approach tailored for Flutter applications:

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  (Screens, Widgets, UI Components)      │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│        State Management Layer           │
│     (Providers - ChangeNotifier)        │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         Business Logic Layer            │
│           (Services)                    │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│          Data Access Layer              │
│         (Repositories)                  │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│           Data Sources                  │
│  (Firebase, Local Storage, APIs)        │
└─────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app/                      # App-level configuration
│   ├── router.dart           # Navigation/routing
│   └── theme.dart            # App theme
├── core/                     # Core utilities and config
│   ├── config/               # App configuration
│   ├── constants/            # App constants
│   ├── theme/                # Theme configuration
│   └── utils/                # Utility functions
├── models/                   # Data models
│   ├── user_model.dart
│   ├── event_model.dart
│   ├── club_model.dart
│   ├── announcement_model.dart
│   ├── registration_model.dart
│   └── attendance_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── event_provider.dart
│   ├── announcement_provider.dart
│   └── registration_provider.dart
├── repositories/             # Data access layer
│   ├── event_repository.dart
│   ├── announcement_repository.dart
│   ├── registration_repository.dart
│   ├── attendance_repository.dart
│   └── mock/                 # Mock implementations
├── services/                 # Business logic services
│   └── (Future services)
├── screens/                  # Full-page screens
│   ├── landing_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── dashboard_screen.dart
│   ├── events_screen.dart
│   ├── event_details_screen.dart
│   ├── announcements_screen.dart
│   └── attendance_screen.dart
└── widgets/                  # Reusable UI components
    └── (Custom widgets)
```

## Layer Responsibilities

### 1. Presentation Layer (Screens & Widgets)

**Responsibility:** Display UI and handle user interactions

- Screens are full-page views
- Widgets are reusable UI components
- No business logic, only UI logic
- Consume state from Providers
- Trigger actions via Providers

**Example:**
```dart
class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        return ListView.builder(
          itemCount: eventProvider.events.length,
          itemBuilder: (context, index) {
            return EventCard(event: eventProvider.events[index]);
          },
        );
      },
    );
  }
}
```

### 2. State Management Layer (Providers)

**Responsibility:** Manage application state and coordinate data flow

- Extends `ChangeNotifier`
- Holds UI state
- Calls services/repositories
- Notifies listeners on state changes
- Handles loading and error states

**Example:**
```dart
class EventProvider extends ChangeNotifier {
  final EventRepository _repository;
  List<EventModel> _events = [];
  bool _isLoading = false;
  
  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();
    
    _events = await _repository.getEvents();
    _isLoading = false;
    notifyListeners();
  }
}
```

### 3. Business Logic Layer (Services)

**Responsibility:** Implement complex business rules

- Stateless operations
- Complex calculations
- Third-party integrations
- Orchestrate multiple repositories
- Transform data between layers

**Example:**
```dart
class NotificationService {
  Future<void> sendEventReminder(EventModel event) async {
    // Complex logic for scheduling notifications
    // Coordinate between multiple data sources
  }
}
```

### 4. Data Access Layer (Repositories)

**Responsibility:** Abstract data sources and provide clean APIs

- CRUD operations
- Data transformation (Model ↔ JSON)
- Error handling
- Cache management
- Abstract Firebase/API details

**Example:**
```dart
class EventRepository {
  final FirebaseFirestore _firestore;
  
  Future<List<EventModel>> getEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs
        .map((doc) => EventModel.fromJson(doc.data()))
        .toList();
  }
}
```

### 5. Data Sources (Firebase, APIs)

**Responsibility:** Actual data storage and retrieval

- Firebase Firestore
- Firebase Authentication
- Firebase Storage
- Cloud Functions
- Local storage (if needed)

## Data Flow

### Reading Data (Top → Down)

```
User Action (UI)
    ↓
Provider.fetchData()
    ↓
Repository.getData()
    ↓
Firebase API Call
    ↓
Data Retrieved
    ↓
Model.fromJson()
    ↓
Provider Updates State
    ↓
UI Rebuilds (notifyListeners)
```

### Writing Data (Bottom → Up)

```
User Action (UI)
    ↓
Provider.createData()
    ↓
Repository.saveData()
    ↓
Model.toJson()
    ↓
Firebase API Call
    ↓
Success/Error
    ↓
Provider Updates State
    ↓
UI Shows Feedback
```

## State Management Strategy

We use the **Provider** pattern with `ChangeNotifier`:

### Provider Setup

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => EventProvider()),
    ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
  ],
  child: MyApp(),
)
```

### Consuming Providers

```dart
// Listen to changes
Consumer<EventProvider>(
  builder: (context, eventProvider, child) {
    return Text('${eventProvider.events.length} events');
  },
)

// Access without listening
Provider.of<EventProvider>(context, listen: false).fetchEvents();
```

## Navigation Architecture

Named routes for maintainability:

```dart
MaterialApp(
  routes: {
    '/': (context) => LandingScreen(),
    '/login': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/events': (context) => EventsScreen(),
    '/event-details': (context) => EventDetailsScreen(),
  },
  initialRoute: '/',
)
```

## Firebase Integration

### Firestore Structure

```
users/
  {userId}/
    - email
    - name
    - role
    - createdAt

clubs/
  {clubId}/
    - name
    - description
    - members[]
    
events/
  {eventId}/
    - title
    - description
    - date
    - clubId
    - capacity
    - registrations[]

announcements/
  {announcementId}/
    - title
    - content
    - clubId
    - createdAt
    
registrations/
  {registrationId}/
    - userId
    - eventId
    - timestamp
    - status
```

## Error Handling

### Repository Level
```dart
try {
  return await _firestore.collection('events').get();
} on FirebaseException catch (e) {
  throw RepositoryException('Firebase error: ${e.message}');
} catch (e) {
  throw RepositoryException('Unexpected error: $e');
}
```

### Provider Level
```dart
try {
  _events = await _repository.getEvents();
} catch (e) {
  _error = e.toString();
} finally {
  _isLoading = false;
  notifyListeners();
}
```

### UI Level
```dart
if (provider.error != null) {
  return ErrorWidget(message: provider.error);
}
```

## Testing Strategy

### Unit Tests
- Models (JSON serialization)
- Repositories (data access)
- Providers (business logic)
- Services (complex operations)

### Widget Tests
- Individual widgets
- Screen layouts
- User interactions

### Integration Tests
- Complete user flows
- Firebase interactions
- End-to-end scenarios

## Security Considerations

1. **Firebase Rules**: Implement Firestore security rules
2. **Authentication**: Use Firebase Auth for all protected routes
3. **Data Validation**: Validate input on client and server
4. **Environment Variables**: Never commit secrets
5. **HTTPS Only**: All API calls use HTTPS

## Performance Optimizations

1. **Lazy Loading**: Load data as needed
2. **Pagination**: Implement for large lists
3. **Caching**: Cache frequently accessed data
4. **Const Constructors**: Use const where possible
5. **Image Optimization**: Compress and cache images

## Future Enhancements

- [ ] Implement caching layer
- [ ] Add offline support
- [ ] Implement real-time streams
- [ ] Add analytics integration
- [ ] Implement push notifications
- [ ] Add performance monitoring
- [ ] Implement error tracking (Sentry)

## Dependencies

### Core
- `flutter`: UI framework
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `provider`: State management

### Development
- `flutter_test`: Testing framework
- `flutter_lints`: Linting rules

## Design Patterns Used

1. **Repository Pattern**: Data access abstraction
2. **Provider Pattern**: State management
3. **Factory Pattern**: Model creation
4. **Singleton Pattern**: Service instances
5. **Observer Pattern**: Change notification

## Coding Standards

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Write self-documenting code
- Add comments for complex logic
- Keep functions small and focused
- Use type annotations
- Handle null safety properly

## References

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
