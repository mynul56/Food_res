import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/food_entity.dart';

class RecommendationSection extends StatelessWidget {
  final List<FoodEntity> foods;
  const RecommendationSection({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) return const SizedBox();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimensions.md, AppDimensions.lg,
              AppDimensions.md, AppDimensions.sm),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🤖', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: AppDimensions.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Picks for You',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  Text('Personalised suggestions',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.textLight)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            itemCount: foods.length,
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.only(right: AppDimensions.md),
              child: _RecommendCard(food: foods[i], isDark: isDark),
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: 80 * i))
                .slideX(begin: 0.2),
          ),
        ),
        const SizedBox(height: AppDimensions.md),
      ],
    );
  }
}

class _RecommendCard extends StatelessWidget {
  final FoodEntity food;
  final bool isDark;
  const _RecommendCard({required this.food, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.foodDetails, arguments: food),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusLg)),
              child: CachedNetworkImage(
                imageUrl: food.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${food.price.toStringAsFixed(2)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
