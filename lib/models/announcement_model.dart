/// Domain model representing a campus/club announcement.
///
/// Can be scoped to a specific club or campus-wide.
class AnnouncementModel {
  final String id;
  final String title;
  final String description;
  final String postedBy;
  final String clubId;
  final String date;
  final AnnouncementPriority priority;
  final AnnouncementScope scope;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.postedBy,
    this.clubId = '',
    required this.date,
    this.priority = AnnouncementPriority.normal,
    this.scope = AnnouncementScope.campusWide,
  });

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? postedBy,
    String? clubId,
    String? date,
    AnnouncementPriority? priority,
    AnnouncementScope? scope,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      postedBy: postedBy ?? this.postedBy,
      clubId: clubId ?? this.clubId,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      scope: scope ?? this.scope,
    );
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AnnouncementModel(
      id: docId ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      postedBy: map['postedBy'] as String? ?? '',
      clubId: map['clubId'] as String? ?? '',
      date: map['date'] as String? ?? '',
      priority: AnnouncementPriority.fromString(
          map['priority'] as String? ?? 'normal'),
      scope:
          AnnouncementScope.fromString(map['scope'] as String? ?? 'campusWide'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'postedBy': postedBy,
      'clubId': clubId,
      'date': date,
      'priority': priority.name,
      'scope': scope.name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnouncementModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Priority level for announcements.
enum AnnouncementPriority {
  normal,
  important,
  urgent;

  static AnnouncementPriority fromString(String value) {
    return AnnouncementPriority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AnnouncementPriority.normal,
    );
  }
}

/// Scope of announcement visibility.
enum AnnouncementScope {
  campusWide,
  clubOnly;

  static AnnouncementScope fromString(String value) {
    return AnnouncementScope.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AnnouncementScope.campusWide,
    );
  }
}
