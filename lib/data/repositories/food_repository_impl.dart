import '../../domain/entities/food_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/mock_food_datasource.dart';

class FoodRepositoryImpl implements FoodRepository {
  @override
  Future<List<FoodEntity>> getFoods() async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));
    return MockFoodDatasource.getFoods();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockFoodDatasource.getCategories();
  }
}
