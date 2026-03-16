/// Domain model representing a campus event.
///
/// Used across Dashboard, EventDetails, Attendance, and admin screens.
/// Designed for easy Firestore serialization when backend is connected.
class EventModel {
  final String id;
  final String name;
  final String club;
  final String clubId;
  final String date;
  final String time;
  final String venue;
  final String description;
  final int capacity;
  final int registeredCount;
  final EventStatus status;
  final String createdBy;

  const EventModel({
    required this.id,
    required this.name,
    required this.club,
    required this.date, required this.time, required this.venue, required this.description, this.clubId = '',
    this.capacity = 0,
    this.registeredCount = 0,
    this.status = EventStatus.published,
    this.createdBy = '',
  });

  /// Whether the event still has capacity for new registrations.
  bool get hasCapacity => capacity == 0 || registeredCount < capacity;

  /// Creates a copy with the given fields replaced.
  EventModel copyWith({
    String? id,
    String? name,
    String? club,
    String? clubId,
    String? date,
    String? time,
    String? venue,
    String? description,
    int? capacity,
    int? registeredCount,
    EventStatus? status,
    String? createdBy,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      club: club ?? this.club,
      clubId: clubId ?? this.clubId,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      description: description ?? this.description,
      capacity: capacity ?? this.capacity,
      registeredCount: registeredCount ?? this.registeredCount,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  /// Deserialize from a Firestore-style map.
  factory EventModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return EventModel(
      id: docId ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      club: map['club'] as String? ?? '',
      clubId: map['clubId'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      venue: map['venue'] as String? ?? '',
      description: map['description'] as String? ?? '',
      capacity: map['capacity'] as int? ?? 0,
      registeredCount: map['registeredCount'] as int? ?? 0,
      status: EventStatus.fromString(map['status'] as String? ?? 'published'),
      createdBy: map['createdBy'] as String? ?? '',
    );
  }

  /// Serialize to a Firestore-compatible map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'club': club,
      'clubId': clubId,
      'date': date,
      'time': time,
      'venue': venue,
      'description': description,
      'capacity': capacity,
      'registeredCount': registeredCount,
      'status': status.name,
      'createdBy': createdBy,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Lifecycle status of an event.
enum EventStatus {
  draft,
  published,
  ongoing,
  completed,
  cancelled;

  static EventStatus fromString(String value) {
    return EventStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EventStatus.published,
    );
  }
}
