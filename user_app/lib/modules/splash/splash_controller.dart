import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    Get.offAllNamed(AppRoutes.auth);
  }
}
