import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/order_entity.dart';
import 'order_controller.dart';

class OrderTrackingView extends GetView<OrderController> {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final order = controller.activeOrder.value;
        if (order == null) {
          return const Center(child: Text('No active order'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            children: [
              // ── Status hero ─────────────────────────────────
              _StatusHero(order: order, step: controller.trackingStep.value)
                  .animate()
                  .scale(
                      begin: const Offset(0.9, 0.9),
                      curve: Curves.elasticOut,
                      duration: 600.ms),

              const SizedBox(height: AppDimensions.lg),

              // ── Step tracker ────────────────────────────────
              _StepTracker(step: controller.trackingStep.value),

              const SizedBox(height: AppDimensions.lg),

              // ── Order summary card ──────────────────────────
              _OrderSummaryCard(order: order, isDark: isDark),

              const SizedBox(height: AppDimensions.xl),
            ],
          ),
        );
      }),
    );
  }
}

class _StatusHero extends StatelessWidget {
  final OrderEntity order;
  final int step;
  const _StatusHero({required this.order, required this.step});

  @override
  Widget build(BuildContext context) {
    final status = OrderStatus.values[step.clamp(0, 3)];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Text(status.emoji, style: const TextStyle(fontSize: 52))
              .animate(
                onPlay: (c) => c.repeat(reverse: true),
              )
              .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: const Duration(seconds: 1, milliseconds: 500)),
          const SizedBox(height: AppDimensions.sm),
          Text(status.label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.textXl,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('${order.restaurantName}',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: AppDimensions.textMd)),
          if (status != OrderStatus.delivered) ...[
            const SizedBox(height: AppDimensions.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: const Text('Est. 20–30 min',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.textSm,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepTracker extends StatelessWidget {
  final int step;
  const _StepTracker({required this.step});

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
      child: Column(
        children: List.generate(OrderStatus.values.length, (i) {
          final status = OrderStatus.values[i];
          final isDone = i <= step;
          final isActive = i == step;
          return Column(
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: AppDimensions.animNormal,
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface),
                      shape: BoxShape.circle,
                      border: isActive
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(status.emoji,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(status.label,
                            style: TextStyle(
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isDone
                                    ? AppColors.textDark
                                    : AppColors.textLight)),
                        if (isActive)
                          Text('In progress...',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: AppDimensions.textSm)),
                        if (isDone && !isActive)
                          const Text('Done ✓',
                              style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: AppDimensions.textSm)),
                      ],
                    ),
                  ),
                ],
              ),
              if (i < OrderStatus.values.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 17, top: 4, bottom: 4),
                  child: AnimatedContainer(
                    duration: AppDimensions.animSlow,
                    width: 2,
                    height: 24,
                    color: i < step
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final OrderEntity order;
  final bool isDark;
  const _OrderSummaryCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: AppDimensions.sm),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${item.quantity}× ${item.food.name}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textMedium)),
                    ),
                    Text('\$${item.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
          const Divider(height: AppDimensions.md),
          _row('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
          _row('Delivery Fee', '\$${order.deliveryFee.toStringAsFixed(2)}'),
          if (order.discount > 0)
            _row('Discount', '-\$${order.discount.toStringAsFixed(2)}',
                color: AppColors.success),
          const Divider(height: AppDimensions.md),
          _row('Total', '\$${order.total.toStringAsFixed(2)}',
              bold: true, color: AppColors.primary),
          const SizedBox(height: AppDimensions.sm),
          _row('Payment', order.paymentMethod, color: AppColors.textMedium),
          if (order.address != null)
            _row('Address', order.address!, color: AppColors.textMedium),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: AppColors.textMedium, fontSize: AppDimensions.textSm)),
          Flexible(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                    color: color ?? AppColors.textDark,
                    fontSize:
                        bold ? AppDimensions.textLg : AppDimensions.textSm)),
          ),
        ],
      ),
    );
  }
}
