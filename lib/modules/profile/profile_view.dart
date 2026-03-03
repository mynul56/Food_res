import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const _menuItems = [
    {
      'icon': Icons.favorite_border_rounded,
      'label': 'Favourites',
      'color': AppColors.error
    },
    {
      'icon': Icons.receipt_long_outlined,
      'label': 'Order History',
      'color': AppColors.primary
    },
    {
      'icon': Icons.location_on_outlined,
      'label': 'Saved Addresses',
      'color': AppColors.info
    },
    {
      'icon': Icons.notifications_none_rounded,
      'label': 'Notifications',
      'color': AppColors.warning
    },
    {
      'icon': Icons.help_outline_rounded,
      'label': 'Help & Support',
      'color': AppColors.success
    },
    {
      'icon': Icons.logout_rounded,
      'label': 'Log Out',
      'color': AppColors.error
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Get.back(),
            ),
            pinned: true,
            backgroundColor: AppColors.primary,
            expandedHeight: 240,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF1B1B2F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryLight,
                              AppColors.primaryDark,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text('👨‍🍳', style: TextStyle(fontSize: 40)),
                        ),
                      )
                          .animate()
                          .scale(curve: Curves.elasticOut, duration: 600.ms)
                          .fadeIn(),
                      const SizedBox(height: AppDimensions.sm),
                      const Text('Inzamam Ul Haq',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700))
                          .animate()
                          .slideY(begin: 0.3, delay: 200.ms)
                          .fadeIn(),
                      Text('inzamam@email.com',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13))
                          .animate()
                          .fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                children: [
                  // Stats row
                  Row(
                    children: [
                      _statCard('12', 'Orders', '📦', isDark),
                      const SizedBox(width: AppDimensions.md),
                      _statCard('5', 'Favourites', '❤️', isDark),
                      const SizedBox(width: AppDimensions.md),
                      _statCard('4.9', 'Rating', '⭐', isDark),
                    ],
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),

                  const SizedBox(height: AppDimensions.lg),

                  // Menu list
                  ...List.generate(_menuItems.length, (i) {
                    final item = _menuItems[i];
                    final color = item['color'] as Color;
                    final icon = item['icon'] as IconData;
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        title: Text(item['label'] as String,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        trailing: Icon(Icons.chevron_right_rounded,
                            color: AppColors.textLight),
                        onTap: () {},
                      ),
                    )
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 100 + 60 * i));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, String emoji, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.primary)),
            Text(label,
                style:
                    const TextStyle(color: AppColors.textLight, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
