import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.cartItems.isNotEmpty
              ? TextButton(
                  onPressed: controller.clearCart,
                  child: const Text('Clear',
                      style: TextStyle(color: AppColors.error)),
                )
              : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmpty(context);
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.md),
                itemCount: controller.cartItems.length,
                itemBuilder: (_, i) {
                  final item = controller.cartItems[i];
                  return Dismissible(
                    key: Key(item.food.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => controller.deleteItem(item.food.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppDimensions.lg),
                      margin: const EdgeInsets.only(bottom: AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLg),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                    ),
                    child: _CartItemTile(
                      item: item,
                      isDark: isDark,
                      onAdd: () => controller.addItem(item.food),
                      onRemove: () => controller.removeItem(item.food),
                    ).animate().fadeIn(delay: Duration(milliseconds: 60 * i)),
                  );
                },
              ),
            ),
            _buildOrderSummary(context, isDark),
          ],
        );
      }),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 72))
              .animate()
              .scale(curve: Curves.elasticOut, duration: 600.ms),
          const SizedBox(height: AppDimensions.md),
          Text('Your cart is empty',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppDimensions.sm),
          Text('Add delicious items from the menu',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMedium)),
          const SizedBox(height: AppDimensions.xl),
          ElevatedButton.icon(
            onPressed: () => Get.offNamed(AppRoutes.home),
            icon: const Icon(Icons.restaurant_menu_rounded),
            label: const Text('Browse Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() => Column(
            children: [
              _summaryRow('Subtotal',
                  '\$${controller.subtotal.toStringAsFixed(2)}', theme),
              const SizedBox(height: AppDimensions.sm),
              _summaryRow('Delivery fee',
                  '\$${controller.deliveryFee.toStringAsFixed(2)}', theme),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
                child: Divider(),
              ),
              _summaryRow(
                'Total',
                '\$${controller.total.toStringAsFixed(2)}',
                theme,
                isTotal: true,
              ),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.checkout),
                  icon: const Icon(Icons.payment_rounded),
                  label: Text(
                      'Checkout  •  \$${controller.total.toStringAsFixed(2)}'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _summaryRow(String label, String value, ThemeData theme,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isTotal
                ? theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)
                : theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textMedium)),
        Text(value,
            style: isTotal
                ? theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w800)
                : theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final dynamic item;
  final bool isDark;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.isDark,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Image.network(
              item.food.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: AppColors.lightSurface,
                  child:
                      const Icon(Icons.fastfood, color: AppColors.textLight)),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.food.name,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('\$${item.food.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ],
            ),
          ),
          // Qty control
          Row(
            children: [
              _circleBtn(Icons.remove, onRemove, AppColors.error),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${item.quantity}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontSize: 16)),
              ),
              _circleBtn(Icons.add, onAdd, AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}
