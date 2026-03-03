import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/order_entity.dart';
import 'order_controller.dart';

class OrdersView extends GetView<OrderController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppDimensions.md, AppDimensions.md, AppDimensions.md, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Orders',
                        style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark)),
                    Text('Track and manage your orders',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppColors.textMedium)),
                  ],
                ),
              ),
            ),

            // ── Active order tracker ────────────────────────────
            SliverToBoxAdapter(
              child: Obx(() {
                if (!controller.hasActiveOrder) return const SizedBox();
                final order = controller.activeOrder.value!;
                return Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: _ActiveOrderCard(
                      order: order, step: controller.trackingStep.value),
                ).animate().fadeIn().slideY(begin: 0.1);
              }),
            ),

            // ── Recent orders section header ────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppDimensions.md,
                  AppDimensions.md, AppDimensions.md, AppDimensions.sm),
              sliver: SliverToBoxAdapter(
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order History',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        if (controller.orderHistory.length > 3)
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.orderHistory),
                            child: const Text('See all',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppDimensions.textSm)),
                          ),
                      ],
                    )),
              ),
            ),

            // ── Order history list (up to 3) ────────────────────
            Obx(() {
              if (controller.orderHistory.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmpty(context));
              }
              final recent = controller.orderHistory.take(3).toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md,
                        vertical: AppDimensions.xs),
                    child: _OrderHistoryCard(order: recent[i]),
                  ).animate().fadeIn(delay: Duration(milliseconds: 60 * i)),
                  childCount: recent.length,
                ),
              );
            }),

            const SliverPadding(
                padding: EdgeInsets.only(bottom: AppDimensions.xxl + 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.xxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📦', style: TextStyle(fontSize: 56)),
            const SizedBox(height: AppDimensions.md),
            Text('No orders yet',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.textMedium)),
            const SizedBox(height: AppDimensions.sm),
            Text('Your order history will appear here',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textLight),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Active order tracking card ───────────────────────────────────────────────
class _ActiveOrderCard extends StatelessWidget {
  final OrderEntity order;
  final int step;
  const _ActiveOrderCard({required this.order, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: AppDimensions.xs),
              const Text('Active Order',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppDimensions.textMd)),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.orderTracking),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: const Text('Track →',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.textSm,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(order.restaurantName,
              style: const TextStyle(
                  color: Colors.white70, fontSize: AppDimensions.textSm)),
          const SizedBox(height: AppDimensions.md),
          // Step indicator
          Row(
            children: List.generate(OrderStatus.values.length, (i) {
              final done = i <= step;
              final status = OrderStatus.values[i];
              return Expanded(
                child: Row(
                  children: [
                    Column(
                      children: [
                        AnimatedContainer(
                          duration: AppDimensions.animNormal,
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: done
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(status.emoji,
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status.label.split(' ').first,
                          style: TextStyle(
                              color: done
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              fontSize: 9,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (i < OrderStatus.values.length - 1)
                      Expanded(
                        child: AnimatedContainer(
                          duration: AppDimensions.animNormal,
                          height: 2,
                          color: i < step
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Past order history card ──────────────────────────────────────────────────
class _OrderHistoryCard extends StatelessWidget {
  final OrderEntity order;
  const _OrderHistoryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child:
                const Center(child: Text('🧾', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.restaurantName,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(order.itemsSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: AppDimensions.textSm)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w800)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(order.status.label,
                    style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
