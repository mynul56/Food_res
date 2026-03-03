import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/entities/category_entity.dart';

class FirebaseFoodDatasource {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<List<FoodEntity>> getFoods() async {
    try {
      final result = await _functions.httpsCallable('getFoods').call();
      final List<dynamic> data = result.data;
      return data
          .map((item) =>
              FoodEntity.fromJson(Map<String, dynamic>.from(item), item['id']))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch foods via backend: $e');
    }
  }

  Future<List<CategoryEntity>> getCategories() async {
    try {
      final result = await _functions.httpsCallable('getCategories').call();
      final List<dynamic> data = result.data;
      return data
          .map((item) => CategoryEntity.fromJson(
              Map<String, dynamic>.from(item), item['id']))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories via backend: $e');
    }
  }

  Future<void> addFood(FoodEntity food) async {
    try {
      await _functions.httpsCallable('addFood').call({
        'food': food.toJson(),
      });
    } catch (e) {
      throw Exception('Failed to add food via backend: $e');
    }
  }

  Future<void> updateFood(FoodEntity food) async {
    try {
      await _functions.httpsCallable('updateFood').call({
        'id': food.id,
        'updates': food.toJson(),
      });
    } catch (e) {
      throw Exception('Failed to update food via backend: $e');
    }
  }

  Future<void> deleteFood(String foodId) async {
    try {
      await _functions.httpsCallable('deleteFood').call({
        'id': foodId,
      });
    } catch (e) {
      throw Exception('Failed to delete food via backend: $e');
    }
  }
}
