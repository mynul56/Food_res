import 'package:get/get.dart';
import '../cart/cart_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // CartController already registered as permanent singleton.
    // No additional controllers needed for checkout (uses StatefulWidget internally).
    Get.find<CartController>();
  }
}
