import 'package:get/get.dart';
import '../../modules/cart/cart_controller.dart';
import '../../modules/orders/order_controller.dart';
import '../../modules/address/address_controller.dart';
import '../../data/repositories/food_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent singletons (exist for entire app lifetime)
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<OrderController>(OrderController(), permanent: true);
    Get.put<AddressController>(AddressController(), permanent: true);
    Get.put(FoodRepositoryImpl(), permanent: true);
  }
}
