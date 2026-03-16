import 'package:unisphere/models/attendance_model.dart';

/// Abstract contract for attendance tracking operations.
abstract class AttendanceRepository {
  /// Returns all attendance records for a given [eventId].
  Future<List<AttendanceModel>> getEventAttendance(String eventId);

  /// Records a check-in for [userId] at [eventId].
  Future<AttendanceModel> checkIn(
    String userId,
    String eventId,
    CheckInMethod method,
  );

  /// Whether [userId] has checked in for [eventId].
  Future<bool> hasCheckedIn(String userId, String eventId);
}
