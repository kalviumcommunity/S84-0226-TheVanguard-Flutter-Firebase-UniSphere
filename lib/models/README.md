# Models

This directory contains all data models used throughout the UniSphere application.

## Purpose

Data models define the structure of data entities and provide:
- Type-safe data structures
- JSON serialization/deserialization
- Data validation
- Clear data contracts between layers

## Current Models

### `user_model.dart`
Represents a user in the UniSphere system.

**Properties:**
- User identification (ID, email, name)
- User profile information
- Authentication metadata
- User roles and permissions

### `event_model.dart`
Represents a club event.

**Properties:**
- Event details (name, description, date, location)
- Event organizer information
- Registration requirements
- Capacity and attendance data

### `club_model.dart`
Represents a student club or organization.

**Properties:**
- Club identification and metadata
- Club administrators and members
- Club description and category
- Contact information

### `announcement_model.dart`
Represents announcements posted by clubs.

**Properties:**
- Announcement content
- Posting timestamp
- Target audience
- Priority level

### `registration_model.dart`
Represents a user's registration for an event.

**Properties:**
- User reference
- Event reference
- Registration timestamp
- Attendance status

### `attendance_model.dart`
Tracks attendance for events.

**Properties:**
- Event reference
- User reference
- Check-in/check-out timestamps
- Attendance status

### `dashboard_data.dart`
Aggregated data for the dashboard view.

**Properties:**
- Summary statistics
- Recent activities
- Upcoming events
- Quick actions

## Best Practices

1. **Immutability**: Use `final` fields where possible
2. **Null Safety**: Properly handle nullable fields
3. **Serialization**: Implement `toJson()` and `fromJson()` methods
4. **Validation**: Add validation logic in constructors or factory methods
5. **Documentation**: Document complex fields and business rules
6. **Naming**: Use clear, descriptive names following Dart conventions

## Example Structure

```dart
class ExampleModel {
  final String id;
  final String name;
  final DateTime createdAt;
  
  const ExampleModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  
  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
```

## Testing

All models should have corresponding unit tests in `test/models/`.
