# Providers

This directory contains state management providers using the Provider pattern.

## Purpose

Providers manage application state and business logic, providing:
- Reactive state management
- UI separation from business logic
- Centralized state updates
- Efficient rebuilds using `ChangeNotifier`

## Current Providers

### `auth_provider.dart`
Manages authentication state and user session.

**Responsibilities:**
- User login/logout
- Session management
- Authentication state notifications
- User profile updates

**Key Methods:**
- `signIn()` - Authenticate user
- `signOut()` - End user session
- `checkAuthState()` - Verify authentication status

### `event_provider.dart`
Manages event-related state.

**Responsibilities:**
- Event list management
- Event filtering and searching
- Event CRUD operations
- Event registration tracking

**Key Methods:**
- `fetchEvents()` - Load events
- `createEvent()` - Create new event
- `updateEvent()` - Modify existing event
- `deleteEvent()` - Remove event

### `announcement_provider.dart`
Manages announcements state.

**Responsibilities:**
- Announcement list management
- Posting new announcements
- Announcement filtering
- Read/unread tracking

**Key Methods:**
- `fetchAnnouncements()` - Load announcements
- `postAnnouncement()` - Create announcement
- `markAsRead()` - Mark announcement as read

### `registration_provider.dart`
Manages event registration state.

**Responsibilities:**
- User registrations
- Registration status tracking
- Registration modifications
- Waitlist management

**Key Methods:**
- `registerForEvent()` - Register user for event
- `cancelRegistration()` - Cancel existing registration
- `fetchUserRegistrations()` - Get user's registrations

## Provider Pattern

All providers extend `ChangeNotifier` and follow this structure:

```dart
import 'package:flutter/foundation.dart';

class ExampleProvider extends ChangeNotifier {
  // Private state
  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;
  
  // Public getters
  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Business logic methods
  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _items = await repository.getItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

## Best Practices

1. **Single Responsibility**: Each provider manages one domain
2. **Immutability**: Don't expose mutable collections directly
3. **Error Handling**: Always handle and expose errors
4. **Loading States**: Track loading states for UI feedback
5. **Dispose**: Clean up resources in `dispose()` method
6. **Testing**: Write unit tests for all provider logic

## Usage in Widgets

```dart
// Provide at app level
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => EventProvider()),
  ],
  child: MyApp(),
)

// Consume in widgets
Consumer<EventProvider>(
  builder: (context, eventProvider, child) {
    return ListView.builder(
      itemCount: eventProvider.events.length,
      itemBuilder: (context, index) {
        return EventCard(event: eventProvider.events[index]);
      },
    );
  },
)

// Or use Provider.of
final authProvider = Provider.of<AuthProvider>(context, listen: false);
```

## Testing

All providers should have corresponding tests in `test/providers/`.
