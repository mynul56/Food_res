import 'package:get/get.dart';
import '../../data/datasources/firebase_food_datasource.dart';
import '../../data/datasources/firebase_order_datasource.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/food_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminController extends GetxController {
  final FirebaseFoodDatasource _foodDatasource = FirebaseFoodDatasource();
  final FirebaseOrderDatasource _orderDatasource = FirebaseOrderDatasource();

  final orders = <OrderEntity>[].obs;
  final foods = <FoodEntity>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    try {
      final fetchedOrders = await _orderDatasource.getAllOrders();
      final fetchedFoods = await _foodDatasource.getFoods();

      orders.assignAll(fetchedOrders);
      foods.assignAll(fetchedFoods);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch admin data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _orderDatasource.updateOrderStatus(orderId, status);
      // Refresh local list
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: status);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: $e');
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed('/auth');
  }
}
