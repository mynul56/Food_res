import 'package:get/get.dart';
import './app_routes.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/splash/splash_binding.dart';
import '../../modules/auth/auth_view.dart';
import '../../modules/auth/auth_binding.dart';
import '../../modules/shell/main_shell_view.dart';
import '../../modules/shell/shell_binding.dart';
import '../../modules/home/home_view.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/search/search_view.dart';
import '../../modules/search/search_controller.dart' as sc;
import '../../modules/orders/orders_view.dart';
import '../../modules/orders/order_tracking_view.dart';
import '../../modules/orders/order_history_view.dart';
import '../../modules/orders/order_controller.dart';
import '../../modules/food_details/food_details_view.dart';
import '../../modules/food_details/food_details_binding.dart';
import '../../modules/cart/cart_view.dart';
import '../../modules/cart/cart_binding.dart';
import '../../modules/checkout/checkout_view.dart';
import '../../modules/checkout/checkout_binding.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/profile/profile_binding.dart';
import '../../modules/address/address_view.dart';
import '../../modules/address/address_controller.dart';

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
    // ── Main App Shell (after login) ──────────────────────────
    GetPage(
      name: AppRoutes.shell,
      page: () => const MainShellView(),
      binding: ShellBinding(),
      transition: Transition.fadeIn,
    ),
    // ── Standalone screen routes (pushed on top) ──────────────
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: BindingsBuilder(
          () => Get.lazyPut<sc.SearchController>(() => sc.SearchController())),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
      binding: BindingsBuilder(
          () => Get.lazyPut<OrderController>(() => OrderController())),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.orderTracking,
      page: () => const OrderTrackingView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryView(),
      transition: Transition.rightToLeft,
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
    GetPage(
      name: AppRoutes.addresses,
      page: () => const AddressView(),
      binding: BindingsBuilder(
          () => Get.lazyPut<AddressController>(() => AddressController())),
      transition: Transition.rightToLeft,
    ),
  ];
}
