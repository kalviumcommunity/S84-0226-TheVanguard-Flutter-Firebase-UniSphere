/// Domain model representing an app user (student or admin).
///
/// The [role] field controls dashboard rendering and route access.
class UserModel {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final List<String> clubIds;
  final String? avatarUrl;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.role = UserRole.student,
    this.clubIds = const [],
    this.avatarUrl,
  });

  /// Whether this user has admin privileges (club admin or super admin).
  bool get isAdmin =>
      role == UserRole.clubAdmin || role == UserRole.superAdmin;

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    UserRole? role,
    List<String>? clubIds,
    String? avatarUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      clubIds: clubIds ?? this.clubIds,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return UserModel(
      uid: docId ?? map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: UserRole.fromString(map['role'] as String? ?? 'student'),
      clubIds: List<String>.from(map['clubIds'] ?? []),
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role.name,
      'clubIds': clubIds,
      'avatarUrl': avatarUrl,
    };
  }
}

/// User role determining dashboard and permission scope.
enum UserRole {
  student,
  clubAdmin,
  superAdmin;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.student,
    );
  }

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.clubAdmin:
        return 'Club Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }
}
