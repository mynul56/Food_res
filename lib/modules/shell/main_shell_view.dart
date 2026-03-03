import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

// ─── Nav item metadata ───────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon, required this.activeIcon, required this.label});
}

const _navItems = [
  _NavItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'Home'),
  _NavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.saved_search_rounded,
      label: 'Search'),
  _NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Orders'),
  _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.manage_accounts_rounded,
      label: 'Profile'),
];

// ─── Main Shell View ─────────────────────────────────────────────────────────
class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final shell = Get.find<MainShellController>();
    final cart = Get.find<CartController>();

    final pages = [
      const HomeView(),
      const SearchView(),
      const OrdersView(),
      const ProfileView(),
    ];

    return Obx(() => Scaffold(
          extendBody: true, // content can draw behind the floating nav
          body: Stack(
            children: [
              // ── Page content ──────────────────────────────────
              IndexedStack(
                index: shell.currentIndex.value,
                children: pages,
              ),

              // ── Floating glassmorphism nav ─────────────────────
              Positioned(
                left: AppDimensions.md,
                right: AppDimensions.md,
                bottom: AppDimensions.md,
                child: Obx(() => _GlassNavBar(
                      currentIndex: shell.currentIndex.value,
                      onTap: shell.goTo,
                    )),
              ),

              // ── Floating glass cart button ─────────────────────
              Obx(() {
                if (cart.itemCount == 0) return const SizedBox.shrink();
                return Positioned(
                  left: 24,
                  right: 24,
                  bottom: AppDimensions.md + 72, // above nav bar
                  child: Center(
                    child: _GlassCartFab(cart: cart)
                        .animate()
                        .scale(
                            begin: const Offset(0.85, 0.85),
                            curve: Curves.elasticOut,
                            duration: 400.ms)
                        .fadeIn(),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}

// ─── Glassmorphism navigation bar ────────────────────────────────────────────
class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _GlassNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.black : Colors.white;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: isDark ? 0.22 : 0.60),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: (isDark ? Colors.white : AppColors.primary)
                  .withValues(alpha: isDark ? 0.12 : 0.18),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.14),
                blurRadius: 28,
                spreadRadius: -6,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems
                  .asMap()
                  .entries
                  .map((e) => _NavPill(
                        item: e.value,
                        isActive: currentIndex == e.key,
                        isDark: isDark,
                        onTap: () => onTap(e.key),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Animated nav pill ───────────────────────────────────────────────────────
class _NavPill extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;
  const _NavPill({
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16.0 : 12.0,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: isDark ? 0.30 : 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          border: isActive
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.45), width: 1.2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon — scales up when active
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: isActive ? 1.15 : 1.0),
              duration: const Duration(milliseconds: 250),
              builder: (_, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                size: 22,
                color: isActive
                    ? AppColors.primary
                    : (isDark ? Colors.white54 : AppColors.textLight),
              ),
            ),
            // Label slides in/out horizontally
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: isActive
                  ? Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          shadows: isDark
                              ? [
                                  Shadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Glass cart FAB ──────────────────────────────────────────────────────────
class _GlassCartFab extends StatelessWidget {
  final CartController cart;
  const _GlassCartFab({required this.cart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.cart),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.45),
                  blurRadius: 24,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Obx(() => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_bag_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${cart.itemCount} item${cart.itemCount > 1 ? 's' : ''} · \$${cart.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
