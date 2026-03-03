import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header gradient ─────────────────────────────
              _buildHeader(isDark),

              const SizedBox(height: AppDimensions.md),

              // ── Settings tiles ──────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                child: Column(
                  children: [
                    _section('Account', [
                      _tile(
                        icon: Icons.location_on_outlined,
                        label: 'Saved Addresses',
                        onTap: () => Get.toNamed(AppRoutes.addresses),
                      ),
                      _tile(
                        icon: Icons.receipt_long_outlined,
                        label: 'Order History',
                        onTap: () => Get.toNamed(AppRoutes.orderHistory),
                      ),
                    ]),

                    const SizedBox(height: AppDimensions.md),

                    _section('Preferences', [
                      _tile(
                        icon: isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        label: 'Dark Mode',
                        trailing: Switch(
                          value: isDark,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) {
                            Get.changeThemeMode(
                                v ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                        onTap: null,
                      ),
                      _tile(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: AppDimensions.md),

                    _section('Support', [
                      _tile(
                        icon: Icons.help_outline_rounded,
                        label: 'Help & FAQ',
                        onTap: () {},
                      ),
                      _tile(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy',
                        onTap: () {},
                      ),
                      _tile(
                        icon: Icons.info_outline_rounded,
                        label: 'About NulEat',
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: AppDimensions.lg),

                    // ── Logout ──────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.auth);
                        },
                        icon: const Icon(Icons.logout_rounded,
                            color: AppColors.error),
                        label: const Text('Log Out',
                            style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w700,
                                fontSize: AppDimensions.textLg)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusLg)),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: AppDimensions.xxl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppDimensions.md, AppDimensions.lg,
          AppDimensions.md, AppDimensions.xl),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Text('👤', style: TextStyle(fontSize: 36)),
            ),
          ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),
          const SizedBox(height: AppDimensions.sm),
          const Text('Guest User',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.textXl,
                  fontWeight: FontWeight.w800)),
          const Text('guest@nuleat.com',
              style: TextStyle(
                  color: Colors.white70, fontSize: AppDimensions.textSm)),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: AppDimensions.xs, bottom: AppDimensions.sm),
          child: Text(title.toUpperCase(),
              style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: AppDimensions.textXs,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(children: tiles),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.08);
  }

  Widget _tile({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Icon(icon, color: AppColors.primary, size: AppDimensions.iconSm),
      ),
      title: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: AppDimensions.textMd)),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      onTap: onTap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
    );
  }
}
