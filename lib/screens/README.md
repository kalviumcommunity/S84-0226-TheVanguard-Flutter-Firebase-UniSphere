# Screens

This directory contains all full-screen views (pages) of the UniSphere application.

## Purpose

Screens represent complete pages in the app, providing:
- Full-page layouts
- Screen-level state management
- Navigation integration
- User workflows

## Current Screens

### Core Screens

#### `landing_screen.dart`
Initial screen shown when the app launches.
- Welcome message
- App overview
- Navigation to login/signup

#### `login_screen.dart`
User authentication screen.
- Email/password login
- Social login options
- Navigate to signup
- Password recovery

#### `home_screen.dart`
Main home screen after login.
- Overview of recent activity
- Quick access to features
- Navigation hub

#### `dashboard_screen.dart`
User dashboard with personalized data.
- User statistics
- Recent registrations
- Upcoming events
- Quick actions

### Event Screens

#### `events_screen.dart`
Browse and search all events.
- Event list/grid view
- Search and filters
- Event categories
- Sort options

#### `event_details_screen.dart`
Detailed view of a single event.
- Full event information
- Registration button
- Share options
- Add to calendar

### Announcement Screens

#### `announcements_screen.dart`
View all announcements.
- Announcement feed
- Filter by club
- Mark as read
- Search functionality

### Attendance Screens

#### `attendance_screen.dart`
Track and manage attendance.
- QR code scanning
- Manual check-in
- Attendance history
- Statistics

### Utility Screens

#### `main_shell.dart`
Main navigation shell/scaffold.
- Bottom navigation bar
- App bar
- Drawer menu
- Persistent UI elements

#### `responsive_layout.dart`
Responsive layout wrapper.
- Breakpoint handling
- Adaptive layouts
- Platform-specific UI

#### `responsive_home.dart`
Responsive home implementation.
- Phone layout
- Tablet layout
- Desktop layout

## Screen Structure

Screens typically follow this structure:

```dart
class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  
  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });
  
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize screen
    _loadEventDetails();
  }
  
  Future<void> _loadEventDetails() async {
    // Load data
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    // Build screen content
    return SingleChildScrollView(
      child: Column(
        children: [
          // Content widgets
        ],
      ),
    );
  }
}
```

## Best Practices

### 1. Scaffold Structure

Always use `Scaffold` as the root widget:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    floatingActionButton: _buildFAB(),
    bottomNavigationBar: _buildBottomNav(),
  );
}
```

### 2. Separate Methods

Break down complex builds into smaller methods:

```dart
Widget _buildHeader() { }
Widget _buildContent() { }
Widget _buildFooter() { }
```

### 3. State Management

Use Provider for screen-level state:

```dart
@override
Widget build(BuildContext context) {
  return Consumer<EventProvider>(
    builder: (context, eventProvider, child) {
      if (eventProvider.isLoading) {
        return const LoadingScreen();
      }
      
      return _buildEventList(eventProvider.events);
    },
  );
}
```

### 4. Loading States

Handle loading, error, and empty states:

```dart
Widget _buildBody() {
  if (_isLoading) return const LoadingIndicator();
  if (_error != null) return ErrorWidget(error: _error!);
  if (_data.isEmpty) return const EmptyStateWidget();
  return _buildContent();
}
```

### 5. Navigation

Use named routes for navigation:

```dart
Navigator.pushNamed(
  context,
  '/event-details',
  arguments: {'eventId': event.id},
);
```

### 6. Responsive Design

Make screens responsive:

```dart
@override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return _buildDesktopLayout();
      }
      return _buildMobileLayout();
    },
  );
}
```

### 7. Lifecycle Management

Properly manage screen lifecycle:

```dart
@override
void initState() {
  super.initState();
  _loadInitialData();
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

## Screen Patterns

### List Screen Pattern

```dart
class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.events.length,
            itemBuilder: (context, index) {
              return EventCard(event: provider.events[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewEvent(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Detail Screen Pattern

```dart
class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  
  const EventDetailScreen({super.key, required this.event});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(event.title),
              background: EventImage(url: event.imageUrl),
            ),
          ),
          SliverToBoxAdapter(
            child: EventDetailsContent(event: event),
          ),
        ],
      ),
    );
  }
}
```

### Form Screen Pattern

```dart
class CreateEventScreen extends StatefulWidget {
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(/* ... */),
            // More form fields
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Submit
    }
  }
}
```

## Testing

Write widget tests for screens:

```dart
testWidgets('EventDetailsScreen displays event info', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: EventDetailsScreen(eventId: 'test123'),
    ),
  );
  
  expect(find.text('Event Title'), findsOneWidget);
});
```

## Future Screens

Potential screens to add:
- Profile screen
- Settings screen
- Search screen
- Notifications screen
- Club management screen
- Admin dashboard
- Analytics screen
