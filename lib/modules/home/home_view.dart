import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../modules/cart/cart_controller.dart';
import 'home_controller.dart';
import 'widgets/food_card.dart';
import 'widgets/category_chip.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/recommendation_section.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.refresh,
        child: CustomScrollView(
          slivers: [
            // ── App Bar with Parallax Header ──────────────────
            _buildSliverAppBar(context, cart, isDark),

            // ── Search Bar ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppDimensions.md, AppDimensions.md, AppDimensions.md, 0),
                child: _buildSearchBar(context, isDark),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
            ),

            // ── Promo Banner Carousel ─────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                child: BannerCarousel(),
              ).animate().fadeIn(delay: 150.ms),
            ),

            // ── Categories ────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildCategorySection(),
            ),

            // ── Section Header: Menu ──────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppDimensions.md,
                  AppDimensions.md, AppDimensions.md, AppDimensions.sm),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  final count = controller.filteredFoods.length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Our Menu',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text('$count items',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textMedium)),
                    ],
                  );
                }),
              ),
            ),

            // ── Food Grid ─────────────────────────────────────
            Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerGrid();
              }
              final foods = controller.filteredFoods;
              if (foods.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmpty());
              }
              return SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => FoodCard(
                      food: foods[i],
                      onTap: () => Get.toNamed(
                        AppRoutes.foodDetails,
                        arguments: foods[i],
                      ),
                    ).animate().fadeIn(
                          delay: Duration(milliseconds: 80 * i),
                        ),
                    childCount: foods.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppDimensions.md,
                    mainAxisSpacing: AppDimensions.md,
                    childAspectRatio: 0.72,
                  ),
                ),
              );
            }),

            // ── AI Recommendations ────────────────────────────
            SliverToBoxAdapter(
              child: Obx(() => controller.isLoading.value
                  ? const SizedBox()
                  : RecommendationSection(
                      foods: controller.recommendations,
                    )),
            ),

            const SliverPadding(
                padding: EdgeInsets.only(bottom: AppDimensions.xxl + 20)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, cart),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, CartController cart, bool isDark) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        title: Row(
          children: [
            const Text('🍽️  ', style: TextStyle(fontSize: 18)),
            Text(
              'NulEat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF6B35),
                    Color(0xFFE5501A),
                    Color(0xFF1B1B2F),
                  ],
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              top: -30,
              right: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            // Greeting text
            Positioned(
              bottom: 60,
              left: AppDimensions.md,
              right: AppDimensions.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_greeting()}, Foodie! 👋',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'What would you like to eat?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Cart badge
        Obx(() => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => Get.toNamed(AppRoutes.profile),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search burgers, pizza, sushi...',
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.primary),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    controller.onSearchChanged('');
                  },
                )
              : const SizedBox()),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Obx(() {
      if (controller.categories.isEmpty) return const SizedBox();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimensions.md,
                AppDimensions.md, AppDimensions.md, AppDimensions.sm),
            child: Text('Category',
                style: Get.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              itemCount: controller.categories.length,
              itemBuilder: (ctx, i) {
                return Obx(() => CategoryChip(
                      category: controller.categories[i],
                      isSelected: controller.selectedCategoryIndex.value == i,
                      onTap: () => controller.selectCategory(i),
                      index: i,
                    ));
              },
            ),
          ),
        ],
      );
    });
  }

  SliverToBoxAdapter _buildShimmerGrid() {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.md,
              mainAxisSpacing: AppDimensions.md,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (_, __) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍽️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AppDimensions.md),
            Text('No items found',
                style: Get.textTheme.titleMedium
                    ?.copyWith(color: AppColors.textMedium)),
            const SizedBox(height: AppDimensions.sm),
            Text('Try a different search or category',
                style: Get.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, CartController cart) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, 'Home', isActive: true, onTap: () {}),
          _navCartItem(cart),
          _navItem(Icons.person_outline_rounded, 'Profile',
              onTap: () => Get.toNamed(AppRoutes.profile)),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label,
      {bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animNormal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md, vertical: AppDimensions.sm),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isActive ? AppColors.primary : AppColors.textLight,
                size: AppDimensions.iconMd),
            if (isActive) ...[
              const SizedBox(width: AppDimensions.xs),
              Text(label,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimensions.textSm,
                  )),
            ]
          ],
        ),
      ),
    );
  }

  Widget _navCartItem(CartController cart) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.cart),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm + 2),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_rounded,
                color: Colors.white, size: AppDimensions.iconMd),
          ),
          Obx(() => cart.itemCount > 0
              ? Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}
