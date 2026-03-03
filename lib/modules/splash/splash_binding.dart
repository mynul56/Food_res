import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Must use Get.put (eager) — SplashView never accesses `controller`
    // in its build(), so lazyPut would never instantiate it and
    // onReady() would never fire to trigger navigation.
    Get.put(SplashController());
  }
}
