class CategoryEntity {
  final String id;
  final String name;
  final String icon;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json, String id) {
    return CategoryEntity(
      id: id,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
    };
  }
}
