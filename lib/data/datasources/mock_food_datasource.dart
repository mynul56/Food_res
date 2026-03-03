import '../models/food_model.dart';
import '../models/category_model.dart';

class MockFoodDatasource {
  static List<FoodModel> getFoods() {
    return [
      // ── BURGERS ─────────────────────────────────────────────
      FoodModel(
        id: 'b1',
        name: 'Classic Smash Burger',
        category: 'Burgers',
        price: 12.99,
        rating: 4.8,
        reviewCount: 324,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
        description:
            'A juicy double smash burger with melted cheddar, caramelized onions, pickles, and our secret house sauce on a brioche bun.',
        isPopular: true,
        calories: 680,
        prepTimeMinutes: 12,
      ),
      FoodModel(
        id: 'b2',
        name: 'BBQ Bacon Burger',
        category: 'Burgers',
        price: 14.49,
        rating: 4.6,
        reviewCount: 218,
        imageUrl:
            'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=600&q=80',
        description:
            'Flame-grilled beef patty topped with crispy bacon strips, tangy BBQ sauce, jalapeños, and aged gouda. A bold flavor experience.',
        isPopular: false,
        calories: 790,
        prepTimeMinutes: 14,
      ),
      FoodModel(
        id: 'b3',
        name: 'Crispy Chicken Burger',
        category: 'Burgers',
        price: 11.99,
        rating: 4.7,
        reviewCount: 185,
        imageUrl:
            'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=600&q=80',
        description:
            'Golden fried chicken thigh with coleslaw, sriracha mayo, and dill pickles on a toasted sesame bun.',
        isPopular: true,
        calories: 620,
        prepTimeMinutes: 10,
      ),

      // ── PIZZA ────────────────────────────────────────────────
      FoodModel(
        id: 'p1',
        name: 'Margherita Truffle',
        category: 'Pizza',
        price: 16.99,
        rating: 4.9,
        reviewCount: 410,
        imageUrl:
            'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600&q=80',
        description:
            'Neapolitan-style pizza with San Marzano tomato sauce, fresh fior di latte, basil leaves, and a drizzle of black truffle oil.',
        isPopular: true,
        calories: 520,
        prepTimeMinutes: 15,
      ),
      FoodModel(
        id: 'p2',
        name: 'Pepperoni Supreme',
        category: 'Pizza',
        price: 17.99,
        rating: 4.7,
        reviewCount: 297,
        imageUrl:
            'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&q=80',
        description:
            'Loaded with premium pepperoni, mozzarella cheese blend, roasted red peppers, and oregano on a hand-tossed crust.',
        isPopular: true,
        calories: 640,
        prepTimeMinutes: 18,
      ),

      // ── SUSHI ────────────────────────────────────────────────
      FoodModel(
        id: 's1',
        name: 'Dragon Roll',
        category: 'Sushi',
        price: 18.99,
        rating: 4.8,
        reviewCount: 156,
        imageUrl:
            'https://images.unsplash.com/photo-1562802378-063ec186a863?w=600&q=80',
        description:
            'Shrimp tempura and cucumber inside, topped with thinly sliced avocado, tobiko, and eel sauce. A restaurant signature.',
        isPopular: true,
        calories: 380,
        prepTimeMinutes: 20,
      ),
      FoodModel(
        id: 's2',
        name: 'Salmon Nigiri Set',
        category: 'Sushi',
        price: 15.99,
        rating: 4.6,
        reviewCount: 134,
        imageUrl:
            'https://images.unsplash.com/photo-1583623025817-d180a2221d0a?w=600&q=80',
        description:
            'Six pieces of premium Atlantic salmon nigiri on perfectly seasoned sushi rice, served with wasabi and pickled ginger.',
        isPopular: false,
        calories: 290,
        prepTimeMinutes: 15,
      ),

      // ── DESSERTS ─────────────────────────────────────────────
      FoodModel(
        id: 'd1',
        name: 'Lava Chocolate Cake',
        category: 'Desserts',
        price: 8.99,
        rating: 4.9,
        reviewCount: 278,
        imageUrl:
            'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=600&q=80',
        description:
            'Warm Belgian chocolate fondant with a gooey molten centre, served with vanilla bean ice cream and berry coulis.',
        isPopular: true,
        calories: 480,
        prepTimeMinutes: 12,
      ),
      FoodModel(
        id: 'd2',
        name: 'Tiramisu Classic',
        category: 'Desserts',
        price: 7.99,
        rating: 4.7,
        reviewCount: 192,
        imageUrl:
            'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&q=80',
        description:
            'Authentic Italian tiramisu with espresso-soaked ladyfingers, mascarpone cream, and a generous dusting of cocoa.',
        isPopular: false,
        calories: 350,
        prepTimeMinutes: 5,
      ),

      // ── DRINKS ───────────────────────────────────────────────
      FoodModel(
        id: 'dr1',
        name: 'Mango Passion Smoothie',
        category: 'Drinks',
        price: 6.49,
        rating: 4.8,
        reviewCount: 213,
        imageUrl:
            'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=600&q=80',
        description:
            'Blended fresh Alphonso mango with passionfruit pulp, coconut milk, and a hint of lime. Tropical perfection.',
        isPopular: true,
        calories: 190,
        prepTimeMinutes: 5,
      ),
      FoodModel(
        id: 'dr2',
        name: 'Espresso Martini',
        category: 'Drinks',
        price: 9.49,
        rating: 4.5,
        reviewCount: 140,
        imageUrl:
            'https://images.unsplash.com/photo-1551788668-ce3fc1a47f22?w=600&q=80',
        description:
            'Freshly pulled espresso shaken with vodka, Kahlúa, and simple syrup. Energising and indulgent in equal measure.',
        isPopular: false,
        calories: 160,
        prepTimeMinutes: 3,
      ),
    ];
  }

  static List<CategoryModel> getCategories() {
    return [
      const CategoryModel(id: 'all', name: 'All', icon: '🍽️'),
      const CategoryModel(id: 'burgers', name: 'Burgers', icon: '🍔'),
      const CategoryModel(id: 'pizza', name: 'Pizza', icon: '🍕'),
      const CategoryModel(id: 'sushi', name: 'Sushi', icon: '🍣'),
      const CategoryModel(id: 'desserts', name: 'Desserts', icon: '🍰'),
      const CategoryModel(id: 'drinks', name: 'Drinks', icon: '🥤'),
    ];
  }
}
