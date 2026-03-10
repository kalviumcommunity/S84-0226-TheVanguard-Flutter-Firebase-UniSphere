# Testing Strategy for UniSphere

This document outlines the testing approach and guidelines for the UniSphere project.

## Testing Philosophy

We follow a pragmatic testing approach that balances:
- **Code Coverage**: Aim for meaningful coverage, not just high percentages
- **Confidence**: Tests should give confidence in deployments
- **Maintainability**: Tests should be easy to understand and maintain
- **Speed**: Tests should run quickly to enable fast feedback

## Test Pyramid

```
        ╱╲
       ╱  ╲         E2E Tests (Few)
      ╱────╲        - Critical user flows
     ╱      ╲       - Firebase integration
    ╱────────╲      
   ╱          ╲     Widget Tests (Some)
  ╱────────────╲    - Screen layouts
 ╱              ╲   - Component interactions
╱────────────────╲  
╱                  ╲ Unit Tests (Many)
────────────────────  - Models, Providers
                      - Business logic
                      - Utilities
```

## Test Structure

```
test/
├── models/              # Unit tests for data models
│   ├── user_model_test.dart
│   ├── event_model_test.dart
│   └── ...
├── providers/           # Unit tests for providers
│   ├── auth_provider_test.dart
│   ├── event_provider_test.dart
│   └── ...
├── repositories/        # Unit tests for repositories
│   ├── event_repository_test.dart
│   └── ...
├── services/            # Unit tests for services
│   └── ...
├── widgets/             # Widget tests
│   ├── event_card_test.dart
│   └── ...
├── screens/             # Screen widget tests
│   ├── login_screen_test.dart
│   └── ...
├── integration/         # Integration tests
│   ├── auth_flow_test.dart
│   ├── event_registration_test.dart
│   └── ...
└── helpers/             # Test utilities
    ├── mock_data.dart
    ├── test_helpers.dart
    └── firebase_mocks.dart
```

## Running Tests

### All Tests
```bash
flutter test
```

### Specific Test File
```bash
flutter test test/models/user_model_test.dart
```

### With Coverage
```bash
flutter test --coverage
```

### Watch Mode (Run tests on file changes)
```bash
flutter test --watch
```

### Integration Tests
```bash
flutter test integration_test/
```

## Unit Tests

### Testing Models

Test data serialization and validation:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:unisphere/models/event_model.dart';

void main() {
  group('EventModel', () {
    test('fromJson creates valid model', () {
      final json = {
        'id': '1',
        'title': 'Test Event',
        'date': '2026-03-15T10:00:00Z',
      };
      
      final event = EventModel.fromJson(json);
      
      expect(event.id, '1');
      expect(event.title, 'Test Event');
      expect(event.date.year, 2026);
    });
    
    test('toJson creates valid JSON', () {
      final event = EventModel(
        id: '1',
        title: 'Test Event',
        date: DateTime(2026, 3, 15),
      );
      
      final json = event.toJson();
      
      expect(json['id'], '1');
      expect(json['title'], 'Test Event');
      expect(json, containsKey('date'));
    });
  });
}
```

### Testing Providers

Test state management logic:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:unisphere/providers/event_provider.dart';
import 'package:unisphere/repositories/event_repository.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  group('EventProvider', () {
    late EventProvider provider;
    late MockEventRepository mockRepository;
    
    setUp(() {
      mockRepository = MockEventRepository();
      provider = EventProvider(mockRepository);
    });
    
    test('fetchEvents updates events list', () async {
      final mockEvents = [
        EventModel(id: '1', title: 'Event 1'),
        EventModel(id: '2', title: 'Event 2'),
      ];
      
      when(mockRepository.getEvents())
          .thenAnswer((_) async => mockEvents);
      
      await provider.fetchEvents();
      
      expect(provider.events.length, 2);
      expect(provider.events[0].title, 'Event 1');
      verify(mockRepository.getEvents()).called(1);
    });
    
    test('fetchEvents handles errors', () async {
      when(mockRepository.getEvents())
          .thenThrow(Exception('Network error'));
      
      await provider.fetchEvents();
      
      expect(provider.error, isNotNull);
      expect(provider.events, isEmpty);
    });
  });
}
```

### Testing Repositories

Test data access logic:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:unisphere/repositories/event_repository.dart';

void main() {
  group('EventRepository', () {
    late FakeFirebaseFirestore firestore;
    late EventRepository repository;
    
    setUp(() {
      firestore = FakeFirebaseFirestore();
      repository = EventRepository(firestore);
    });
    
    test('getEvents returns list of events', () async {
      // Add test data
      await firestore.collection('events').add({
        'id': '1',
        'title': 'Test Event',
        'date': DateTime.now().toIso8601String(),
      });
      
      final events = await repository.getEvents();
      
      expect(events.length, 1);
      expect(events[0].title, 'Test Event');
    });
  });
}
```

## Widget Tests

Test UI components in isolation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisphere/widgets/event_card.dart';
import 'package:unisphere/models/event_model.dart';

void main() {
  testWidgets('EventCard displays event information', (tester) async {
    final event = EventModel(
      id: '1',
      title: 'Test Event',
      description: 'Test Description',
      date: DateTime(2026, 3, 15),
    );
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard(event: event),
        ),
      ),
    );
    
    expect(find.text('Test Event'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
  
  testWidgets('EventCard triggers onTap callback', (tester) async {
    bool tapped = false;
    final event = EventModel(id: '1', title: 'Test Event');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: event,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    
    await tester.tap(find.byType(EventCard));
    
    expect(tapped, true);
  });
}
```

## Integration Tests

Test complete user flows:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:unisphere/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Authentication Flow', () {
    testWidgets('User can login successfully', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Enter credentials
      await tester.enterText(
        find.byKey(Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(Key('password_field')),
        'password123',
      );
      
      // Submit
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      
      // Verify navigation to home
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
```

## Testing Best Practices

### 1. Arrange-Act-Assert (AAA) Pattern

```dart
test('description', () {
  // Arrange - Set up test data
  final user = User(name: 'John');
  
  // Act - Perform action
  final result = user.getName();
  
  // Assert - Verify result
  expect(result, 'John');
});
```

### 2. One Assertion Per Test

```dart
// Good
test('user has correct name', () {
  expect(user.name, 'John');
});

test('user has correct email', () {
  expect(user.email, 'john@example.com');
});

// Avoid
test('user has correct properties', () {
  expect(user.name, 'John');
  expect(user.email, 'john@example.com');
  expect(user.age, 25);
});
```

### 3. Use Test Groups

```dart
group('UserModel', () {
  group('constructor', () {
    test('creates valid user', () { });
    test('throws on invalid email', () { });
  });
  
  group('serialization', () {
    test('toJson works correctly', () { });
    test('fromJson works correctly', () { });
  });
});
```

### 4. Use setUp and tearDown

```dart
void main() {
  late Database db;
  
  setUp(() {
    db = Database.create();
  });
  
  tearDown(() {
    db.close();
  });
  
  test('can insert data', () {
    db.insert(/* ... */);
  });
}
```

### 5. Test Edge Cases

```dart
test('handles null input', () { });
test('handles empty list', () { });
test('handles network timeout', () { });
test('handles invalid JSON', () { });
```

## Mocking

### Using Mockito

```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([EventRepository])
import 'event_provider_test.mocks.dart';

void main() {
  final mockRepo = MockEventRepository();
  
  when(mockRepo.getEvents())
      .thenAnswer((_) async => []);
}
```

### Mocking Firebase

Use `fake_cloud_firestore` for Firestore tests:

```dart
dependencies:
  fake_cloud_firestore: ^2.0.0
  
final firestore = FakeFirebaseFirestore();
```

## Coverage Goals

- **Models**: > 90%
- **Providers**: > 80%
- **Repositories**: > 75%
- **Widgets**: > 70%
- **Overall**: > 75%

## View Coverage Report

```bash
# Generate coverage
flutter test --coverage

# Convert to HTML (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## Continuous Integration

Tests run automatically on:
- Every push to main/develop
- Every pull request
- Before deployment

See `.github/workflows/flutter-test.yml` for CI configuration.

## Common Testing Utilities

Create test helpers in `test/helpers/`:

```dart
// test_helpers.dart
Widget wrapWithMaterialApp(Widget widget) {
  return MaterialApp(home: Scaffold(body: widget));
}

// mock_data.dart
final mockEvents = [
  EventModel(id: '1', title: 'Event 1'),
  EventModel(id: '2', title: 'Event 2'),
];

// firebase_mocks.dart
FakeFirebaseFirestore createMockFirestore() {
  final firestore = FakeFirebaseFirestore();
  // Add mock data
  return firestore;
}
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)

## Troubleshooting

### Tests Timeout

Increase timeout:
```dart
test('slow test', () async {
  // test code
}, timeout: Timeout(Duration(seconds: 30)));
```

### Flutter Driver Issues

Ensure driver is connected:
```bash
flutter drive --target=test_driver/app.dart
```

### Mock Not Working

Verify mock is generated:
```bash
flutter pub run build_runner build
```

---

**Remember**: Good tests are:
- ✅ Fast
- ✅ Independent
- ✅ Repeatable
- ✅ Self-validating
- ✅ Timely
