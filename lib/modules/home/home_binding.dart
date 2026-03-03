import 'package:get/get.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/usecases/get_foods_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/recommend_foods_usecase.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final repo = Get.find<FoodRepositoryImpl>();
    Get.lazyPut(() => HomeController(
          getFoodsUsecase: GetFoodsUsecase(repo),
          getCategoriesUsecase: GetCategoriesUsecase(repo),
          recommendFoodsUsecase: RecommendFoodsUsecase(),
        ));
  }
}
