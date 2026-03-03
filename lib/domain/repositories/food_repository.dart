import '../entities/food_entity.dart';
import '../entities/category_entity.dart';

abstract class FoodRepository {
  Future<List<FoodEntity>> getFoods();
  Future<List<CategoryEntity>> getCategories();
}
