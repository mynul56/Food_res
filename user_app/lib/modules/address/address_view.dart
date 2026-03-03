import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'address_controller.dart';
import '../../domain/entities/address_entity.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: const Text('Add Address',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (controller.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📍', style: TextStyle(fontSize: 56)),
                const SizedBox(height: AppDimensions.md),
                Text('No saved addresses',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: AppColors.textMedium)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.md),
          itemCount: controller.addresses.length,
          itemBuilder: (ctx, i) {
            final a = controller.addresses[i];
            return _AddressCard(
              address: a,
              isDark: isDark,
              onSetDefault: () => controller.setDefault(a.id),
              onDelete: () => controller.deleteAddress(a.id),
            ).animate().fadeIn(delay: Duration(milliseconds: 50 * i));
          },
        );
      }),
    );
  }

  void _showAddDialog(BuildContext context) {
    final labelCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Address',
            style: TextStyle(fontWeight: FontWeight.w700)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(
                controller: labelCtrl, hint: 'Label (e.g. Home, Work)'),
            const SizedBox(height: AppDimensions.sm),
            _DialogField(controller: streetCtrl, hint: 'Street address'),
            const SizedBox(height: AppDimensions.sm),
            _DialogField(controller: cityCtrl, hint: 'City'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (labelCtrl.text.isNotEmpty &&
                  streetCtrl.text.isNotEmpty &&
                  cityCtrl.text.isNotEmpty) {
                controller.addAddress(
                    labelCtrl.text, streetCtrl.text, cityCtrl.text);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull))),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool isDark;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;
  const _AddressCard({
    required this.address,
    required this.isDark,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(address.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 28),
      ),
      child: GestureDetector(
        onTap: onSetDefault,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: address.isDefault
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
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
                child: Icon(
                  address.label.toLowerCase() == 'work'
                      ? Icons.work_outline_rounded
                      : Icons.home_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(address.label,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: AppDimensions.textMd)),
                        if (address.isDefault) ...[
                          const SizedBox(width: AppDimensions.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull),
                            ),
                            child: const Text('Default',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                    Text(address.fullAddress,
                        style: const TextStyle(
                            color: AppColors.textMedium,
                            fontSize: AppDimensions.textSm)),
                  ],
                ),
              ),
              if (!address.isDefault)
                TextButton(
                  onPressed: onSetDefault,
                  child: const Text('Set Default',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _DialogField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
      ),
    );
  }
}
