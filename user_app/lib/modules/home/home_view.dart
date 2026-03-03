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
import 'widgets/featured_carousel.dart';

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
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.md),
                child: BannerCarousel(),
              ).animate().fadeIn(delay: 150.ms),
            ),

            // ── Featured Restaurant Carousel ───────────────────
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.only(top: AppDimensions.sm),
                child: FeaturedCarousel(),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),
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
                    (ctx, i) {
                      final delay = Duration(milliseconds: 60 * i);
                      return FoodCard(
                        food: foods[i],
                        onTap: () => Get.toNamed(
                          AppRoutes.foodDetails,
                          arguments: foods[i],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: delay, duration: 350.ms)
                          .slideY(
                            begin: 0.25,
                            end: 0,
                            delay: delay,
                            duration: 380.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .scale(
                            begin: const Offset(0.88, 0.88),
                            end: const Offset(1, 1),
                            delay: delay,
                            duration: 380.ms,
                            curve: Curves.easeOutBack,
                          );
                    },
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

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍽️  ', style: TextStyle(fontSize: 18)),
            Flexible(
              child: Text(
                'NulEat',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
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
                  color: Colors.white.withValues(alpha: 0.08),
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
                  color: Colors.white.withValues(alpha: 0.06),
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'What would you like to eat?',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
            color: Colors.black.withValues(alpha: 0.07),
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

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}
