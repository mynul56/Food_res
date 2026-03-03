import '../../domain/entities/restaurant_entity.dart';

class MockRestaurantDataSource {
  static List<RestaurantEntity> getRestaurants() {
    return [
      const RestaurantEntity(
        id: 'r1',
        name: 'Burger Palace',
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
        cuisineType: 'American',
        rating: 4.8,
        reviewCount: 1240,
        deliveryTimeMin: 20,
        deliveryFee: 1.99,
        categories: ['Burgers', 'Fries', 'Shakes'],
        isFeatured: true,
      ),
      const RestaurantEntity(
        id: 'r2',
        name: 'Sushi Zen',
        imageUrl:
            'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600',
        cuisineType: 'Japanese',
        rating: 4.7,
        reviewCount: 890,
        deliveryTimeMin: 30,
        deliveryFee: 2.49,
        categories: ['Sushi', 'Ramen', 'Tempura'],
        isFeatured: true,
      ),
      const RestaurantEntity(
        id: 'r3',
        name: 'Pizza Maestro',
        imageUrl:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
        cuisineType: 'Italian',
        rating: 4.6,
        reviewCount: 2100,
        deliveryTimeMin: 25,
        deliveryFee: 0.99,
        categories: ['Pizza', 'Pasta', 'Salad'],
        isFeatured: false,
      ),
      const RestaurantEntity(
        id: 'r4',
        name: 'Spice Garden',
        imageUrl:
            'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600',
        cuisineType: 'Indian',
        rating: 4.5,
        reviewCount: 670,
        deliveryTimeMin: 35,
        deliveryFee: 1.49,
        categories: ['Curry', 'Tandoori', 'Biryani'],
        isFeatured: false,
      ),
      const RestaurantEntity(
        id: 'r5',
        name: 'Taco Fiesta',
        imageUrl:
            'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600',
        cuisineType: 'Mexican',
        rating: 4.4,
        reviewCount: 543,
        deliveryTimeMin: 18,
        deliveryFee: 1.29,
        categories: ['Tacos', 'Burritos', 'Nachos'],
        isFeatured: false,
      ),
      const RestaurantEntity(
        id: 'r6',
        name: 'The Green Bowl',
        imageUrl:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600',
        cuisineType: 'Healthy',
        rating: 4.9,
        reviewCount: 384,
        deliveryTimeMin: 22,
        deliveryFee: 2.99,
        categories: ['Salads', 'Bowls', 'Smoothies'],
        isFeatured: true,
      ),
    ];
  }
}
