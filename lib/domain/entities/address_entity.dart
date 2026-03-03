class AddressEntity {
  final String id;
  final String label; // e.g. "Home", "Work"
  final String street;
  final String city;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    this.isDefault = false,
  });

  AddressEntity copyWith({
    String? label,
    String? street,
    String? city,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress => '$street, $city';
}
