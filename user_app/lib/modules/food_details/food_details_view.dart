import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/food_entity.dart';
import '../cart/cart_controller.dart';
import '../home/home_controller.dart';

class FoodDetailsView extends StatelessWidget {
  const FoodDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final food = Get.arguments as FoodEntity;
    final cart = Get.find<CartController>();
    final home = Get.find<HomeController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero Image App Bar ─────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            actions: [
              Obx(() {
                final isFav = home.isFavorite(food.id);
                return GestureDetector(
                  onTap: () => home.toggleFavorite(food.id),
                  child: Container(
                    margin: const EdgeInsets.all(AppDimensions.sm),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppColors.error : Colors.white,
                      size: 20,
                    ),
                  ).animate(target: isFav ? 1 : 0).scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.3, 1.3),
                      ),
                );
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'food_${food.id}',
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: AppColors.lightSurface),
                ),
              ),
            ),
          ),

          // ── Details Content ────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusXl),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + Popular badge
                    Row(
                      children: [
                        _tag(food.category, AppColors.primary),
                        if (food.isPopular) ...[
                          const SizedBox(width: AppDimensions.sm),
                          _tag('🔥 Popular', AppColors.error),
                        ],
                      ],
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: AppDimensions.sm),
                    // Name + Rating row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            food.name,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: AppColors.starGold, size: 20),
                                const SizedBox(width: 4),
                                Text(food.rating.toStringAsFixed(1),
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w800)),
                              ],
                            ),
                            Text('(${food.reviewCount} reviews)',
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: AppColors.textLight)),
                          ],
                        ),
                      ],
                    ).animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: AppDimensions.md),

                    // Quick stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _stat('⏱️', '${food.prepTimeMinutes} min', 'Prep time'),
                        _divider(),
                        _stat('🔥', '${food.calories} kcal', 'Calories'),
                        _divider(),
                        _stat('⭐', food.rating.toStringAsFixed(1), 'Rating'),
                      ],
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                    const SizedBox(height: AppDimensions.lg),

                    // Description
                    Text('Description',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      food.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                        height: 1.6,
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: AppDimensions.xl),

                    // Price + Add to Cart
                    Obx(() {
                      final qty = cart.quantityOf(food.id);
                      return Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total price',
                                  style: theme.textTheme.labelSmall
                                      ?.copyWith(color: AppColors.textLight)),
                              Text(
                                '\$${food.price.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (qty > 0)
                            _quantityRow(cart, food, qty)
                          else
                            ElevatedButton.icon(
                              onPressed: () {
                                cart.addItem(food);
                              },
                              icon: const Icon(Icons.shopping_cart_outlined,
                                  size: 18),
                              label: const Text('Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 14),
                              ),
                            ).animate().scale(
                                  begin: const Offset(0.95, 0.95),
                                  duration: 300.ms,
                                  curve: Curves.elasticOut,
                                ),
                        ],
                      );
                    }),

                    const SizedBox(height: AppDimensions.lg),

                    // Checkout button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(AppRoutes.cart),
                        icon: const Icon(Icons.receipt_long_outlined, size: 18),
                        label: const Text('View Cart & Checkout'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusLg),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: AppDimensions.xl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: AppDimensions.textSm,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _stat(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        Text(label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.lightSurface,
    );
  }

  Widget _quantityRow(CartController cart, FoodEntity food, int qty) {
    return Row(
      children: [
        _qtyBtn(Icons.remove, () => cart.removeItem(food), AppColors.error),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Text('$qty',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary)),
        ),
        _qtyBtn(Icons.add, () => cart.addItem(food), AppColors.primary),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
