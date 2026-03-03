import 'package:get/get.dart';
import './app_routes.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/splash/splash_binding.dart';
import '../../modules/auth/auth_view.dart';
import '../../modules/auth/auth_binding.dart';
import '../../modules/home/home_view.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/food_details/food_details_view.dart';
import '../../modules/food_details/food_details_binding.dart';
import '../../modules/cart/cart_view.dart';
import '../../modules/cart/cart_binding.dart';
import '../../modules/checkout/checkout_view.dart';
import '../../modules/checkout/checkout_binding.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/profile/profile_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.foodDetails,
      page: () => const FoodDetailsView(),
      binding: FoodDetailsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
