import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;
  final isLogin = true.obs; // toggle between Login & Sign Up

  void toggleMode() => isLogin.toggle();
  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmVisibility() => obscureConfirm.toggle();

  Future<void> submit() async {
    if (isLoading.value) return;

    // Basic validation
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Missing fields',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (!isLogin.value && password.value != confirmPassword.value) {
      Get.snackbar(
        'Password mismatch',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    // Simulate network auth call
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoading.value = false;

    // Navigate to home
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> continueAsGuest() async {
    Get.offAllNamed(AppRoutes.home);
  }
}
