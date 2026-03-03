import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../cart/cart_controller.dart';
import '../home/home_view.dart';
import '../search/search_view.dart';
import '../orders/orders_view.dart';
import '../profile/profile_view.dart';

class MainShellController extends GetxController {
  final currentIndex = 0.obs;
  void goTo(int i) => currentIndex.value = i;
}

class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final shell = Get.find<MainShellController>();
    final cart = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      const HomeView(),
      const SearchView(),
      const OrdersView(),
      const ProfileView(),
    ];

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: shell.currentIndex.value,
            children: pages,
          ),
          floatingActionButton: Obx(() {
            if (cart.itemCount == 0) return const SizedBox.shrink();
            return FloatingActionButton.extended(
              heroTag: 'cart_fab',
              onPressed: () => Get.toNamed(AppRoutes.cart),
              backgroundColor: AppColors.primary,
              elevation: 6,
              icon: const Icon(Icons.shopping_cart_rounded,
                  color: Colors.white, size: 20),
              label: Text(
                '${cart.itemCount} item${cart.itemCount > 1 ? 's' : ''} · \$${cart.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            );
          }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Obx(
                () => BottomNavigationBar(
                  currentIndex: shell.currentIndex.value,
                  onTap: shell.goTo,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: AppColors.textLight,
                  selectedFontSize: AppDimensions.textSm,
                  unselectedFontSize: AppDimensions.textSm,
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w700),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search_outlined),
                      activeIcon: Icon(Icons.search_rounded),
                      label: 'Search',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt_long_outlined),
                      activeIcon: Icon(Icons.receipt_long_rounded),
                      label: 'Orders',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_rounded),
                      activeIcon: Icon(Icons.person_rounded),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
