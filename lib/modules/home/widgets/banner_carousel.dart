import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  static const _banners = [
    _Banner(
      title: '50% OFF',
      subtitle: 'All Burgers Today!',
      emoji: '🍔',
      gradient: [Color(0xFFFF6B35), Color(0xFFE5501A)],
    ),
    _Banner(
      title: 'Free Delivery',
      subtitle: 'On orders over \$20',
      emoji: '🛵',
      gradient: [Color(0xFF5B8CFF), Color(0xFF3A6BD4)],
    ),
    _Banner(
      title: 'New on Menu',
      subtitle: 'Dragon Rolls are here!',
      emoji: '🍣',
      gradient: [Color(0xFF4CAF82), Color(0xFF2E7D52)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          options: CarouselOptions(
            height: 130,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            onPageChanged: (i, _) => setState(() => _current = i),
          ),
          itemBuilder: (ctx, i, _) => _BannerCard(banner: _banners[i]),
        ),
        const SizedBox(height: AppDimensions.sm),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: AppDimensions.animNormal,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _current == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _current == i
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final _Banner banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: banner.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: banner.gradient.first.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Text(
              banner.emoji,
              style: const TextStyle(fontSize: 72),
            )
                .animate(
                  onPlay: (c) => c.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.08, 1.08),
                  duration: 2.seconds,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Text(
                    'Order Now →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradient;
  const _Banner({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
  });
}
