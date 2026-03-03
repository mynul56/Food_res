import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/entities/category_entity.dart';
import 'mock_food_datasource.dart';

class FirebaseFoodDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FoodEntity>> getFoods() async {
    try {
      final snapshot = await _firestore.collection('foods').get();
      if (snapshot.docs.isEmpty) {
        // Fallback: Seed data if empty
        await _seedMockData();
        return MockFoodDatasource.getFoods();
      }
      return snapshot.docs
          .map((doc) => FoodEntity.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch foods: $e');
    }
  }

  Future<List<CategoryEntity>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      if (snapshot.docs.isEmpty) {
        return MockFoodDatasource.getCategories()
            .map((model) => CategoryEntity(
                  id: model.id,
                  name: model.name,
                  icon: model.icon,
                ))
            .toList();
      }
      return snapshot.docs
          .map((doc) => CategoryEntity.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<void> addFood(FoodEntity food) async {
    try {
      await _firestore.collection('foods').doc(food.id).set(food.toJson());
    } catch (e) {
      throw Exception('Failed to add food: $e');
    }
  }

  Future<void> updateFood(FoodEntity food) async {
    try {
      await _firestore.collection('foods').doc(food.id).update(food.toJson());
    } catch (e) {
      throw Exception('Failed to update food: $e');
    }
  }

  Future<void> deleteFood(String foodId) async {
    try {
      await _firestore.collection('foods').doc(foodId).delete();
    } catch (e) {
      throw Exception('Failed to delete food: $e');
    }
  }

  Future<void> _seedMockData() async {
    final batch = _firestore.batch();

    final foods = MockFoodDatasource.getFoods();
    for (var food in foods) {
      final foodRef = _firestore.collection('foods').doc(food.id);
      batch.set(foodRef, {
        'name': food.name,
        'category': food.category,
        'price': food.price,
        'rating': food.rating,
        'reviewCount': food.reviewCount,
        'imageUrl': food.imageUrl,
        'description': food.description,
        'isPopular': food.isPopular,
        'calories': food.calories,
        'prepTimeMinutes': food.prepTimeMinutes,
        'isFavorite': food.isFavorite,
      });
    }

    final categories = MockFoodDatasource.getCategories();
    for (var cat in categories) {
      final catRef = _firestore.collection('categories').doc(cat.id);
      batch.set(catRef, {
        'name': cat.name,
        'icon': cat.icon,
      });
    }

    await batch.commit();
  }
}
