import '../../domain/entities/food_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/firebase_food_datasource.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FirebaseFoodDatasource _dataSource = FirebaseFoodDatasource();

  @override
  Future<List<FoodEntity>> getFoods() async {
    return _dataSource.getFoods();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return _dataSource.getCategories();
  }
}
