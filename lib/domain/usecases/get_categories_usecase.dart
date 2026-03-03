import '../entities/category_entity.dart';
import '../repositories/food_repository.dart';

class GetCategoriesUsecase {
  final FoodRepository repository;
  GetCategoriesUsecase(this.repository);

  Future<List<CategoryEntity>> call() => repository.getCategories();
}
