import '../entities/food_entity.dart';
import '../repositories/food_repository.dart';

class GetFoodsUsecase {
  final FoodRepository repository;
  GetFoodsUsecase(this.repository);

  Future<List<FoodEntity>> call() => repository.getFoods();
}
