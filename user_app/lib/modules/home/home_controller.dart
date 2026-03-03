import 'package:get/get.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_foods_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/recommend_foods_usecase.dart';

class HomeController extends GetxController {
  final GetFoodsUsecase getFoodsUsecase;
  final GetCategoriesUsecase getCategoriesUsecase;
  final RecommendFoodsUsecase recommendFoodsUsecase;

  HomeController({
    required this.getFoodsUsecase,
    required this.getCategoriesUsecase,
    required this.recommendFoodsUsecase,
  });

  final _allFoods = <FoodEntity>[].obs;
  final categories = <CategoryEntity>[].obs;
  final selectedCategoryIndex = 0.obs;
  final searchQuery = ''.obs;
  final isLoading = true.obs;
  final favorites = <String>{}.obs;

  List<FoodEntity> get filteredFoods {
    var foods = [..._allFoods];

    // Category filter
    if (selectedCategoryIndex.value > 0) {
      final cat = categories[selectedCategoryIndex.value].name;
      foods = foods.where((f) => f.category == cat).toList();
    }

    // Search filter
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isNotEmpty) {
      foods = foods
          .where((f) =>
              f.name.toLowerCase().contains(q) ||
              f.category.toLowerCase().contains(q))
          .toList();
    }

    return foods;
  }

  List<FoodEntity> get recommendations {
    return recommendFoodsUsecase.call(
      allFoods: _allFoods,
      cartFoods: [],
    );
  }

  List<FoodEntity> get popularFoods =>
      _allFoods.where((f) => f.isPopular).toList();

  @override
  void onInit() {
    super.onInit();
    _loadData();
    debounce(searchQuery, (_) => update(),
        time: const Duration(milliseconds: 300));
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        getFoodsUsecase.call(),
        getCategoriesUsecase.call(),
      ]);
      _allFoods.assignAll(results[0] as List<FoodEntity>);
      categories.assignAll(results[1] as List<CategoryEntity>);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => _loadData();

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void toggleFavorite(String foodId) {
    if (favorites.contains(foodId)) {
      favorites.remove(foodId);
    } else {
      favorites.add(foodId);
    }
  }

  bool isFavorite(String foodId) => favorites.contains(foodId);
}
