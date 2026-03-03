import '../entities/food_entity.dart';

class RecommendFoodsUsecase {
  List<FoodEntity> call({
    required List<FoodEntity> allFoods,
    required List<FoodEntity> cartFoods,
  }) {
    if (cartFoods.isEmpty) {
      // No cart context — return popular foods
      return allFoods.where((f) => f.isPopular).take(6).toList();
    }

    final categories = cartFoods.map((f) => f.category).toSet();

    // Score each food based on: same category match + rating + popularity
    final scored = allFoods
        .where((food) => !cartFoods.any((c) => c.id == food.id))
        .map((food) {
      double score = 0;
      if (categories.contains(food.category)) score += 3;
      score += food.rating;
      if (food.isPopular) score += 1;
      return MapEntry(food, score);
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return scored.take(6).map((e) => e.key).toList();
  }
}
