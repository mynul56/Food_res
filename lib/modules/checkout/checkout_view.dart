import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../address/address_controller.dart';
import '../cart/cart_controller.dart';
import '../orders/order_controller.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _cart = Get.find<CartController>();
  final _addressCtrl = Get.find<AddressController>();
  final _orderCtrl = Get.find<OrderController>();

  String _paymentMethod = 'Cash on Delivery';
  final _promoCtrl = TextEditingController();
  String? _promoMsg;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Delivery address ──────────────────────────────
            _sectionTitle('📍 Delivery Address'),
            _AddressPicker(addressCtrl: _addressCtrl, isDark: isDark),

            const SizedBox(height: AppDimensions.md),

            // ── Payment method ────────────────────────────────
            _sectionTitle('💳 Payment Method'),
            _PaymentSelector(
              selected: _paymentMethod,
              onChanged: (v) => setState(() => _paymentMethod = v),
            ),

            const SizedBox(height: AppDimensions.md),

            // ── Promo code ────────────────────────────────────
            _sectionTitle('🎁 Promo Code'),
            Obx(() {
              if (_cart.promoCode.value.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.success, size: 18),
                      const SizedBox(width: AppDimensions.xs),
                      Expanded(
                        child: Text(
                            '${_cart.promoCode.value} applied — ${(_cart.promoDiscount.value * 100).toInt()}% off!',
                            style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600)),
                      ),
                      GestureDetector(
                        onTap: () => _cart.removePromo(),
                        child: const Icon(Icons.close_rounded,
                            size: 16, color: AppColors.textLight),
                      ),
                    ],
                  ),
                );
              }
              return _PromoField(
                controller: _promoCtrl,
                message: _promoMsg,
                onApply: () {
                  final ok = _cart.applyPromo(_promoCtrl.text);
                  setState(() {
                    _promoMsg = ok
                        ? null
                        : 'Invalid promo code. Try SAVE10 or NULEAT20';
                  });
                },
              );
            }),

            const SizedBox(height: AppDimensions.md),

            // ── Order summary ─────────────────────────────────
            _sectionTitle('🧾 Order Summary'),
            Obx(() => _OrderSummary(cart: _cart, isDark: isDark)),

            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppDimensions.md, 0, AppDimensions.md, AppDimensions.lg),
        child: Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _cart.cartItems.isEmpty
                    ? null
                    : () {
                        final addr = _addressCtrl.defaultAddress?.fullAddress ??
                            'No address';
                        _orderCtrl.placeOrder(
                          cart: _cart,
                          address: addr,
                          paymentMethod: _paymentMethod,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg)),
                  elevation: 4,
                ),
                child: Text(
                  'Place Order · \$${_cart.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: AppDimensions.textLg),
                ),
              ),
            )).animate().fadeIn(delay: 300.ms),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.sm),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: AppDimensions.textLg)),
      );
}

class _AddressPicker extends StatelessWidget {
  final AddressController addressCtrl;
  final bool isDark;
  const _AddressPicker({required this.addressCtrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final addr = addressCtrl.defaultAddress;
      return GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.addresses),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: addr == null
                    ? const Text('No address — tap to add',
                        style: TextStyle(color: AppColors.textLight))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(addr.label,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          Text(addr.fullAddress,
                              style: const TextStyle(
                                  color: AppColors.textMedium,
                                  fontSize: AppDimensions.textSm)),
                        ],
                      ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textLight),
            ],
          ),
        ),
      );
    });
  }
}

class _PaymentSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _PaymentSelector({required this.selected, required this.onChanged});

  static const _methods = [
    ('Cash on Delivery', '💵'),
    ('Card', '💳'),
    ('bKash', '🟣'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _methods.map((m) {
        final isSelected = selected == m.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(m.$1),
            child: AnimatedContainer(
              duration: AppDimensions.animNormal,
              margin: const EdgeInsets.only(right: AppDimensions.xs),
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.lightSurface,
                    width: isSelected ? 2 : 1),
              ),
              child: Column(
                children: [
                  Text(m.$2, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(m.$1.split(' ').first,
                      style: TextStyle(
                          fontSize: AppDimensions.textXs,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textMedium)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PromoField extends StatelessWidget {
  final TextEditingController controller;
  final String? message;
  final VoidCallback onApply;
  const _PromoField(
      {required this.controller, required this.message, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter promo code',
                  hintStyle: const TextStyle(fontSize: AppDimensions.textSm),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd)),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd))),
              child: const Text('Apply'),
            ),
          ],
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(message!,
                style: const TextStyle(
                    color: AppColors.error, fontSize: AppDimensions.textSm)),
          ),
      ],
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartController cart;
  final bool isDark;
  const _OrderSummary({required this.cart, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          ...cart.cartItems.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${item.quantity}× ${item.food.name}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.textMedium,
                              fontSize: AppDimensions.textSm)),
                    ),
                    Text('\$${item.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
          Divider(height: AppDimensions.md, color: AppColors.lightSurface),
          _row('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
          _row('Delivery', '\$${cart.deliveryFee.toStringAsFixed(2)}'),
          if (cart.promoDiscount.value > 0)
            _row('Discount', '-\$${cart.discount.toStringAsFixed(2)}',
                color: AppColors.success),
          const Divider(height: AppDimensions.md),
          _row('Total', '\$${cart.total.toStringAsFixed(2)}',
              bold: true, color: AppColors.primary),
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
              style: const TextStyle(
                  color: AppColors.textMedium, fontSize: AppDimensions.textSm)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: color ?? AppColors.textDark,
                  fontSize:
                      bold ? AppDimensions.textLg : AppDimensions.textSm)),
        ],
      ),
    );
  }
}
