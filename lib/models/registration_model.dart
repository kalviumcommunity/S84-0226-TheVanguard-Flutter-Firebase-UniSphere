/// Domain model representing a user's registration for an event.
class RegistrationModel {
  final String id;
  final String userId;
  final String eventId;
  final RegistrationStatus status;
  final DateTime registeredAt;
  final DateTime? cancelledAt;

  const RegistrationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    this.status = RegistrationStatus.registered,
    required this.registeredAt,
    this.cancelledAt,
  });

  RegistrationModel copyWith({
    String? id,
    String? userId,
    String? eventId,
    RegistrationStatus? status,
    DateTime? registeredAt,
    DateTime? cancelledAt,
  }) {
    return RegistrationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map,
      {String? docId}) {
    return RegistrationModel(
      id: docId ?? map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      eventId: map['eventId'] as String? ?? '',
      status: RegistrationStatus.fromString(
          map['status'] as String? ?? 'registered'),
      registeredAt: map['registeredAt'] != null
          ? DateTime.parse(map['registeredAt'] as String)
          : DateTime.now(),
      cancelledAt: map['cancelledAt'] != null
          ? DateTime.parse(map['cancelledAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eventId': eventId,
      'status': status.name,
      'registeredAt': registeredAt.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }
}

/// Registration lifecycle status.
enum RegistrationStatus {
  registered,
  waitlisted,
  cancelled,
  checkedIn;

  static RegistrationStatus fromString(String value) {
    return RegistrationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RegistrationStatus.registered,
    );
  }

  String get displayName {
    switch (this) {
      case RegistrationStatus.registered:
        return 'Registered';
      case RegistrationStatus.waitlisted:
        return 'Waitlisted';
      case RegistrationStatus.cancelled:
        return 'Cancelled';
      case RegistrationStatus.checkedIn:
        return 'Checked In';
    }
  }
}
