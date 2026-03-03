import 'package:get/get.dart';
import 'cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // CartController is already registered as a permanent singleton
    // via InitialBinding. This ensures it's accessible on this route.
    Get.find<CartController>();
  }
}
