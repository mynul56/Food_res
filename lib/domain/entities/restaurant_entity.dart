class RestaurantEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisineType;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMin; // minutes
  final double deliveryFee;
  final List<String> categories;
  final bool isOpen;
  final bool isFeatured;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisineType,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMin,
    required this.deliveryFee,
    required this.categories,
    this.isOpen = true,
    this.isFeatured = false,
  });
}
