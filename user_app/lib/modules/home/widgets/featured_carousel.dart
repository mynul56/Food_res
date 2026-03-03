import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/datasources/mock_restaurant_datasource.dart';
import '../../../domain/entities/restaurant_entity.dart';

/// A full-width horizontal PageView carousel with:
/// - 3D perspective tilt on off-centre cards
/// - Parallax image sliding inside the card
/// - Scale + opacity fade on inactive cards
/// - Animated dot page indicator
class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _pageCtrl;
  double _page = 0;
  final List<RestaurantEntity> _cards =
      MockRestaurantDataSource.getRestaurants();

  static const _viewportFraction = 0.82;
  static const _cardHeight = 210.0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(viewportFraction: _viewportFraction);
    _pageCtrl.addListener(() {
      setState(() => _page = _pageCtrl.page ?? 0);
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppDimensions.md, 0, AppDimensions.md, AppDimensions.sm),
          child: Row(
            children: [
              const Text('🔥 Featured',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
              const Spacer(),
              Text('${_cards.length} places',
                  style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: AppDimensions.textSm)),
            ],
          ),
        ),

        // 3D PageView carousel
        SizedBox(
          height: _cardHeight,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: _cards.length,
            clipBehavior: Clip.none,
            itemBuilder: (ctx, i) {
              final delta = i - _page;
              // Clamp how much perspective we apply
              final t = delta.clamp(-1.0, 1.0);

              // Scale: centre=1.0, edges=0.88
              final scale = 1.0 - (0.12 * t.abs());
              // Opacity: centre=1.0, edges=0.60
              final opacity = 1.0 - (0.4 * t.abs());
              // Rotation around Y-axis: ±8°
              final rotY = t * 0.12; // radians
              // Parallax offset for the image inside the card
              final parallax = delta * 40.0;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(rotY)
                  ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0)),
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: _RestaurantCard(
                    restaurant: _cards[i],
                    parallaxOffset: parallax,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppDimensions.sm),

        // Animated dot indicator
        _DotIndicator(count: _cards.length, page: _page),
      ],
    );
  }
}

// ─── Restaurant card with parallax image ────────────────────────────────────
class _RestaurantCard extends StatefulWidget {
  final RestaurantEntity restaurant;
  final double parallaxOffset;
  const _RestaurantCard(
      {required this.restaurant, required this.parallaxOffset});

  @override
  State<_RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<_RestaurantCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 0.03,
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _pressCtrl.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _pressCtrl.reverse();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _pressCtrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _pressCtrl,
        builder: (_, child) => Transform.scale(
          scale: 1.0 - _pressCtrl.value,
          child: child,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _pressed ? 0.08 : 0.22),
                blurRadius: _pressed ? 6 : 20,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Parallax background image ─────────────────
                Transform.translate(
                  offset: Offset(widget.parallaxOffset, 0),
                  child: CachedNetworkImage(
                    imageUrl: r.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.lightSurface,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.lightSurface,
                      child: const Icon(Icons.store_outlined,
                          color: AppColors.textLight, size: 48),
                    ),
                  ),
                ),

                // ── Dark gradient overlay ─────────────────────
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.30),
                        Colors.black.withValues(alpha: 0.78),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),

                // ── Card content ─────────────────────────────
                Positioned(
                  left: AppDimensions.md,
                  right: AppDimensions.md,
                  bottom: AppDimensions.md,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badges row
                      Row(
                        children: [
                          _Badge(
                            icon: Icons.star_rounded,
                            label: r.rating.toStringAsFixed(1),
                            color: AppColors.starGold,
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          _Badge(
                            icon: Icons.delivery_dining_rounded,
                            label: r.deliveryFee == 0
                                ? 'Free'
                                : '\$${r.deliveryFee.toStringAsFixed(2)}',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          _Badge(
                            icon: Icons.timer_outlined,
                            label: '${r.deliveryTimeMin} min',
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Restaurant name
                      Text(
                        r.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Cuisine + categories
                      Text(
                        '${r.cuisineType} · ${r.categories.take(2).join(', ')}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ── "Open" pill top-right ─────────────────────
                Positioned(
                  top: AppDimensions.sm,
                  right: AppDimensions.sm,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: r.isOpen
                          ? AppColors.success.withValues(alpha: 0.9)
                          : Colors.red.withValues(alpha: 0.85),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      r.isOpen ? '● Open' : '● Closed',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.04, curve: Curves.easeOut);
  }
}

// ─── Small badge widget ───────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 11),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ─── Animated dot indicator ───────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  final int count;
  final double page;
  const _DotIndicator({required this.count, required this.page});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final dist = (i - page).abs().clamp(0.0, 1.0);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 6 + (14 * (1.0 - dist)),
          height: 6,
          decoration: BoxDecoration(
            color: Color.lerp(AppColors.primary,
                AppColors.textLight.withValues(alpha: 0.4), dist),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        );
      }),
    );
  }
}
