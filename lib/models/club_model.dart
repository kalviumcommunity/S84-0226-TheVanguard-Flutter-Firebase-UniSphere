/// Domain model representing a campus club or student community.
class ClubModel {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final List<String> adminIds;
  final List<String> memberIds;
  final int memberCount;

  const ClubModel({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    this.adminIds = const [],
    this.memberIds = const [],
    this.memberCount = 0,
  });

  ClubModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    List<String>? adminIds,
    List<String>? memberIds,
    int? memberCount,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      adminIds: adminIds ?? this.adminIds,
      memberIds: memberIds ?? this.memberIds,
      memberCount: memberCount ?? this.memberCount,
    );
  }

  factory ClubModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ClubModel(
      id: docId ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      logoUrl: map['logoUrl'] as String?,
      adminIds: List<String>.from(map['adminIds'] ?? []),
      memberIds: List<String>.from(map['memberIds'] ?? []),
      memberCount: map['memberCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'adminIds': adminIds,
      'memberIds': memberIds,
      'memberCount': memberCount,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClubModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
