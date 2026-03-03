import 'package:get/get.dart';
import '../cart/cart_controller.dart';
import '../home/home_controller.dart';

class FoodDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // FoodDetails depends on CartController (permanent) and
    // HomeController (for favorites toggle) — both already registered.
    Get.find<CartController>();
    Get.find<HomeController>();
  }
}
