# Widgets

This directory contains reusable UI components (widgets).

## Purpose

Custom widgets provide:
- Reusable UI components
- Consistent design system
- Reduced code duplication
- Easier maintenance and testing

## Widget Organization

Widgets should be organized by:
- **Type** (buttons, cards, inputs, etc.)
- **Feature** (event widgets, profile widgets, etc.)
- **Complexity** (atomic, molecular, organism components)

## Best Practices

### 1. Widget Composition

Build complex UIs from smaller, reusable widgets:

```dart
// Atomic widget
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

// Molecular widget
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            EventImage(url: event.imageUrl),
            EventTitle(title: event.title),
            EventDate(date: event.date),
            PrimaryButton(
              text: 'Register',
              onPressed: () => _handleRegister(context),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. Stateless vs Stateful

- Use `StatelessWidget` when widget doesn't manage state
- Use `StatefulWidget` only when widget needs internal state
- Prefer state management (Provider) over local widget state

### 3. Const Constructors

Use `const` constructors when possible for performance:

```dart
class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  
  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
```

### 4. Named Parameters

Use named parameters for better readability:

```dart
CustomCard(
  title: 'Event Title',
  subtitle: 'Event Description',
  trailing: Icon(Icons.arrow_forward),
  onTap: () => print('Tapped'),
)
```

### 5. Theme Integration

Use theme colors and styles:

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  
  return Text(
    'Hello',
    style: theme.textTheme.headlineMedium,
  );
}
```

## Common Widget Types

### Buttons
- Primary buttons
- Secondary buttons
- Icon buttons
- Floating action buttons

### Cards
- Event cards
- Announcement cards
- User cards
- Summary cards

### Forms
- Text input fields
- Dropdown selectors
- Date pickers
- Validation wrappers

### Lists
- Event lists
- User lists
- Announcement feeds
- Search results

### Dialogs
- Confirmation dialogs
- Input dialogs
- Alert dialogs
- Loading dialogs

### Navigation
- Custom app bars
- Bottom navigation
- Drawer menus
- Tab bars

## Testing Widgets

Write widget tests for custom widgets:

```dart
testWidgets('PrimaryButton displays text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PrimaryButton(
          text: 'Click Me',
          onPressed: () {},
        ),
      ),
    ),
  );
  
  expect(find.text('Click Me'), findsOneWidget);
});
```

## Responsive Design

Make widgets responsive using `MediaQuery` or `LayoutBuilder`:

```dart
class ResponsiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        
        return Card(
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Column(
              children: [
                // Content
              ],
            ),
          ),
        );
      },
    );
  }
}
```

## Accessibility

Ensure widgets are accessible:

```dart
Semantics(
  label: 'Event registration button',
  button: true,
  enabled: true,
  child: PrimaryButton(
    text: 'Register',
    onPressed: _handleRegister,
  ),
)
```

## Documentation

Document complex widgets:

```dart
/// A card that displays event information.
///
/// The [EventCard] shows the event title, date, location,
/// and a registration button. When tapped, it navigates
/// to the event details screen.
///
/// Example:
/// ```dart
/// EventCard(
///   event: myEvent,
///   onTap: () => Navigator.push(...),
/// )
/// ```
class EventCard extends StatelessWidget {
  // Implementation
}
```

## Future Additions

Consider adding:
- Animation wrappers
- Shimmer loading widgets
- Empty state widgets
- Error state widgets
- Skeleton screens
