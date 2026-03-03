import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../cart/cart_controller.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  int _selectedPayment = 0;
  bool _orderPlaced = false;
  final _addressController =
      TextEditingController(text: '123 Main Street, New York, NY 10001');

  static const _paymentMethods = [
    {'icon': '💳', 'label': 'Credit Card'},
    {'icon': '📱', 'label': 'Apple Pay'},
    {'icon': '💵', 'label': 'Cash on Delivery'},
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final theme = Theme.of(context);

    if (_orderPlaced) {
      return _buildConfirmation(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Delivery Address ───────────────────────────────
            _sectionTitle('📍 Delivery Address', theme),
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: _cardDecoration(context),
              child: Column(
                children: [
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Street Address',
                      prefixIcon: Icon(Icons.location_on_outlined,
                          color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Row(
                    children: const [
                      Icon(Icons.access_time_rounded,
                          size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text('Estimated: 25–35 min',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textMedium)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: AppDimensions.lg),

            // ── Payment Method ─────────────────────────────────
            _sectionTitle('💳 Payment Method', theme),
            ...List.generate(
              _paymentMethods.length,
              (i) => GestureDetector(
                onTap: () => setState(() => _selectedPayment = i),
                child: AnimatedContainer(
                  duration: AppDimensions.animNormal,
                  margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: _selectedPayment == i
                        ? AppColors.primary.withOpacity(0.08)
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    border: _selectedPayment == i
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : Border.all(color: Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(_paymentMethods[i]['icon']!,
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: AppDimensions.md),
                      Text(_paymentMethods[i]['label']!,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      if (_selectedPayment == i)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 150 + 60 * i)),
            ),

            const SizedBox(height: AppDimensions.lg),

            // ── Order Summary ──────────────────────────────────
            _sectionTitle('🧾 Order Summary', theme),
            Obx(() => Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: _cardDecoration(context),
                  child: Column(
                    children: [
                      ...cart.cartItems.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.xs),
                            child: Row(
                              children: [
                                Text('${item.quantity}×',
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(width: AppDimensions.sm),
                                Expanded(
                                    child: Text(item.food.name,
                                        style: theme.textTheme.bodyMedium)),
                                Text('\$${item.total.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )),
                      const Divider(height: AppDimensions.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textMedium)),
                          Text('\$${cart.subtotal.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textMedium)),
                          Text('\$${cart.deliveryFee.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium),
                        ],
                      ),
                      const Divider(height: AppDimensions.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          Text('\$${cart.total.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: AppDimensions.xl),

            // ── Place Order Button ─────────────────────────────
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: cart.isLoading.value
                        ? null
                        : () {
                            cart.placeOrder();
                            setState(() => _orderPlaced = true);
                          },
                    icon: cart.isLoading.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.rocket_launch_rounded),
                    label: Text(cart.isLoading.value
                        ? 'Placing Order...'
                        : 'Place Order'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                )),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmation(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('✅', style: TextStyle(fontSize: 56)),
                ),
              )
                  .animate()
                  .scale(
                    curve: Curves.elasticOut,
                    duration: 800.ms,
                  )
                  .fadeIn(),
              const SizedBox(height: AppDimensions.xl),
              Text('Order Placed! 🎉',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800))
                  .animate()
                  .slideY(begin: 0.3, delay: 300.ms)
                  .fadeIn(),
              const SizedBox(height: AppDimensions.sm),
              Text('Your food is being prepared and will arrive in 25–35 minutes.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMedium))
                  .animate()
                  .fadeIn(delay: 500.ms),
              const SizedBox(height: AppDimensions.xxl),
              ElevatedButton.icon(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14)),
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Text(title,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}
