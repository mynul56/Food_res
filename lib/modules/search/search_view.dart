import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../modules/cart/cart_controller.dart';
import 'search_controller.dart' as sc;

class SearchView extends GetView<sc.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cart = Get.find<CartController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimensions.md, AppDimensions.md, AppDimensions.md, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discover',
                      style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                  Text('Find your perfect meal',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textMedium)),
                  const SizedBox(height: AppDimensions.md),
                  // ── Search field ─────────────────────────────
                  _SearchField(controller: controller, isDark: isDark),
                ],
              ),
            ),

            // ── Body scrollable ────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  return _buildResults(context, theme, cart);
                }
                return _buildDiscoverPage(context, theme);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverPage(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Trending ────────────────────────────
          Text('🔥 Trending Now',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: controller.trendingTags
                .asMap()
                .entries
                .map((e) => _TrendingChip(
                      label: e.value,
                      colorIndex: e.key,
                      onTap: () => controller.searchTag(e.value),
                    )
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 50 * e.key)))
                .toList(),
          ),

          const SizedBox(height: AppDimensions.lg),

          // ── Recent searches ──────────────────────
          Obx(() {
            if (controller.recentSearches.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    GestureDetector(
                      onTap: controller.clearRecent,
                      child: Text('Clear all',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: AppDimensions.textSm,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                ...controller.recentSearches.map((q) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history_rounded,
                          color: AppColors.textLight),
                      title: Text(q,
                          style:
                              const TextStyle(fontSize: AppDimensions.textMd)),
                      onTap: () => controller.searchTag(q),
                    )),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResults(
      BuildContext context, ThemeData theme, CartController cart) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: AppColors.primary));
      }
      if (controller.results.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔍', style: TextStyle(fontSize: 48)),
              const SizedBox(height: AppDimensions.md),
              Text('No results for "${controller.searchQuery.value}"',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.textMedium)),
              const SizedBox(height: AppDimensions.sm),
              Text('Try a different keyword',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textLight)),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.md),
        itemCount: controller.results.length,
        itemBuilder: (ctx, i) {
          final food = controller.results[i];
          return Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.sm),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(AppDimensions.sm),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                child: Image.network(food.imageUrl,
                    width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(food.name,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(food.category,
                  style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: AppDimensions.textSm)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${food.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800)),
                  GestureDetector(
                    onTap: () => cart.addItem(food),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: const Text('Add',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDimensions.textSm,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
              onTap: () => Get.toNamed(AppRoutes.foodDetails, arguments: food),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 40 * i));
        },
      );
    });
  }
}

class _SearchField extends StatelessWidget {
  final sc.SearchController controller;
  final bool isDark;
  const _SearchField({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: TextField(
        autofocus: false,
        onChanged: controller.onChanged,
        decoration: InputDecoration(
          hintText: 'Search for food, restaurants...',
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.primary),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox()),
        ),
      ),
    );
  }
}

class _TrendingChip extends StatelessWidget {
  final String label;
  final int colorIndex;
  final VoidCallback onTap;
  const _TrendingChip(
      {required this.label, required this.colorIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color =
        AppColors.categoryColors[colorIndex % AppColors.categoryColors.length];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md, vertical: AppDimensions.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: AppDimensions.textMd)),
      ),
    );
  }
}
