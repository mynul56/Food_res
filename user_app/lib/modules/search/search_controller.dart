import 'package:get/get.dart';
import '../../data/datasources/mock_food_datasource.dart';
import '../../domain/entities/food_entity.dart';

class SearchController extends GetxController {
  final searchQuery = ''.obs;
  final results = <FoodEntity>[].obs;
  final isLoading = false.obs;
  final recentSearches = <String>[].obs;

  static const _trending = [
    'Burger',
    'Pizza',
    'Sushi',
    'Tacos',
    'Salad',
    'Ramen',
    'Pasta',
  ];
  List<String> get trendingTags => _trending;

  final _allFoods = <FoodEntity>[];

  @override
  void onInit() {
    super.onInit();
    _allFoods.addAll(MockFoodDatasource.getFoods());
    debounce(
      searchQuery,
      _performSearch,
      time: const Duration(milliseconds: 300),
    );
  }

  void onChanged(String query) {
    searchQuery.value = query;
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      results.clear();
      return;
    }
    isLoading.value = true;
    final q = query.toLowerCase();
    final filtered = _allFoods
        .where((f) =>
            f.name.toLowerCase().contains(q) ||
            f.category.toLowerCase().contains(q))
        .toList();
    results.assignAll(filtered);
    isLoading.value = false;

    // Save to recent (max 5, no duplicates)
    final term = query.trim();
    recentSearches.remove(term);
    recentSearches.insert(0, term);
    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }
  }

  void searchTag(String tag) {
    searchQuery.value = tag;
    _performSearch(tag);
  }

  void clearRecent() => recentSearches.clear();

  void clearSearch() {
    searchQuery.value = '';
    results.clear();
  }
}
