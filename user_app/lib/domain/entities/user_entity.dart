class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role; // 'customer' or 'admin'
  final String? profileImageUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'customer',
    this.profileImageUrl,
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  factory UserEntity.fromJson(Map<String, dynamic> json, String id) {
    return UserEntity(
      id: id,
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
