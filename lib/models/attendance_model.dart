/// Domain model representing an attendance check-in record.
class AttendanceModel {
  final String id;
  final String userId;
  final String eventId;
  final DateTime checkInTime;
  final CheckInMethod method;

  const AttendanceModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.checkInTime,
    this.method = CheckInMethod.manual,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AttendanceModel(
      id: docId ?? map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      eventId: map['eventId'] as String? ?? '',
      checkInTime: map['checkInTime'] != null
          ? DateTime.parse(map['checkInTime'] as String)
          : DateTime.now(),
      method:
          CheckInMethod.fromString(map['method'] as String? ?? 'manual'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eventId': eventId,
      'checkInTime': checkInTime.toIso8601String(),
      'method': method.name,
    };
  }
}

/// How the attendance was recorded.
enum CheckInMethod {
  qrScan,
  manual;

  static CheckInMethod fromString(String value) {
    return CheckInMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CheckInMethod.manual,
    );
  }

  String get displayName {
    switch (this) {
      case CheckInMethod.qrScan:
        return 'QR Scan';
      case CheckInMethod.manual:
        return 'Manual';
    }
  }
}
