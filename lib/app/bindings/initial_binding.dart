import 'package:get/get.dart';
import '../../modules/cart/cart_controller.dart';
import '../../data/repositories/food_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent singletons (exist for entire app lifetime)
    Get.put<CartController>(CartController(), permanent: true);
    Get.put(FoodRepositoryImpl(), permanent: true);
  }
}
