import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/category_entity.dart';

class CategoryChip extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        AppColors.categoryColors[index % AppColors.categoryColors.length];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animNormal,
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: AppDimensions.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md, vertical: AppDimensions.sm),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: AppDimensions.animNormal,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: AppDimensions.textMd,
              ),
              child: Text(category.name),
            ),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)),
    );
  }
}
