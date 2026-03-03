import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/order_entity.dart';
import '../cart/cart_controller.dart';
import 'order_controller.dart';

class OrderHistoryView extends GetView<OrderController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.orderHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📜', style: TextStyle(fontSize: 56)),
                const SizedBox(height: AppDimensions.md),
                Text('No past orders',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: AppColors.textMedium)),
                const SizedBox(height: AppDimensions.sm),
                Text('Your completed orders will appear here',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textLight),
                    textAlign: TextAlign.center),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.md),
          itemCount: controller.orderHistory.length,
          itemBuilder: (ctx, i) {
            final order = controller.orderHistory[i];
            return Card(
              margin: const EdgeInsets.only(bottom: AppDimensions.md),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
              color: isDark ? AppColors.darkCard : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(order.restaurantName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppDimensions.textLg)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusFull),
                          ),
                          child: Text(order.status.label,
                              style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                        '${order.placedAt.day}/${order.placedAt.month}/${order.placedAt.year}',
                        style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: AppDimensions.textSm)),
                    const SizedBox(height: AppDimensions.sm),
                    Text(order.itemsSummary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textMedium,
                            fontSize: AppDimensions.textSm)),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total: \$${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: AppDimensions.textLg)),
                        ElevatedButton.icon(
                          onPressed: () => controller.reorder(order, cart),
                          icon: const Icon(Icons.replay_rounded, size: 16),
                          label: const Text('Reorder'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.md, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusFull)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 60 * i));
          },
        );
      }),
    );
  }
}
