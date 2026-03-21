import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../features/home/widgets/home_menu_overlay.dart';
import '../../../shared/widgets/brand_top_bar.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../providers/spin_provider.dart';
import '../widgets/selectable_shop_card.dart';

class SpinPage extends StatefulWidget {
  const SpinPage({super.key});

  @override
  State<SpinPage> createState() => _SpinPageState();
}

class _SpinPageState extends State<SpinPage> {
  late final SpinProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = SpinProvider();
    _provider.initialize();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    final String targetRoute = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.directory,
      2 => AppRoutes.spin,
      3 => AppRoutes.about,
      _ => AppRoutes.spin,
    };

    if (targetRoute == AppRoutes.spin) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  void _openMenuOverlay() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'spin_menu',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder:
          (
            BuildContext dialogContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return HomeMenuOverlay(
              activeItem: HomeMenuItem.cantDecide,
              onClose: () => Navigator.of(dialogContext).pop(),
              onHome: () => _navigateFromOverlay(dialogContext, AppRoutes.home),
              onAbout: () =>
                  _navigateFromOverlay(dialogContext, AppRoutes.about),
              onDirectory: () =>
                  _navigateFromOverlay(dialogContext, AppRoutes.directory),
              onCantDecide: () => Navigator.of(dialogContext).pop(),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final CurvedAnimation curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curve,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, -0.03),
                  end: Offset.zero,
                ).animate(curve),
                child: child,
              ),
            );
          },
    );
  }

  void _navigateFromOverlay(BuildContext dialogContext, String route) {
    Navigator.of(dialogContext).pop();
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _provider,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BrandTopBar(
                    onBrandTap: () =>
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.home,
                        ),
                    onMenuTap: _openMenuOverlay,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      'Can\'t Decide?',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 34 / 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Center(
                    child: Text(
                      'Add Stores and Spin the Wheel!',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _WheelPreview(
                    labels: _provider.filteredShops
                        .map((shop) => shop.name)
                        .take(6)
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: _provider.canSpin
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Spin animation will be added in the next phase.',
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.border,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                        child: Text(
                          'Spin Me!',
                          style: AppTextStyles.button.copyWith(fontSize: 16 / 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SpinSearchBar(onChanged: _provider.setQuery),
                  const SizedBox(height: AppSpacing.md),
                  _buildListSection(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 2,
            onTap: _onBottomNavTap,
          ),
        );
      },
    );
  }

  Widget _buildListSection() {
    if (_provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_provider.errorMessage != null) {
      return Center(
        child: Text(
          _provider.errorMessage!,
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      );
    }

    final shops = _provider.filteredShops;
    if (shops.isEmpty) {
      return Center(
        child: Text(
          'No shops match your search.',
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: shops.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (BuildContext context, int index) {
        final shop = shops[index];
        return SelectableShopCard(
          shop: shop,
          isSelected: _provider.isSelected(shop.id),
          onToggle: () {
            _provider.toggleShopSelection(shop.id);
          },
        );
      },
    );
  }
}

class _WheelPreview extends StatelessWidget {
  const _WheelPreview({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final List<String> displayLabels = labels.isEmpty
        ? <String>['Shop 1', 'Shop 2', 'Shop 3', 'Shop 4', 'Shop 5', 'Shop 6']
        : labels;

    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              size: const Size(220, 220),
              painter: _WheelPainter(segmentCount: displayLabels.length),
            ),
            ..._buildWheelLabels(displayLabels),
            Positioned(
              top: 4,
              child: Icon(
                Icons.arrow_drop_down_rounded,
                size: 34,
                color: AppColors.secondary,
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWheelLabels(List<String> names) {
    const double radius = 62;
    final double step = (2 * 3.141592653589793) / names.length;

    return List<Widget>.generate(names.length, (int index) {
      final double angle = (-3.141592653589793 / 2) + (step * index) + step / 2;
      final double dx = radius * (index.isEven ? 0.92 : 1.0) * cos(angle);
      final double dy = radius * (index.isEven ? 0.92 : 1.0) * sin(angle);
      final String text = names[index];

      return Positioned(
        left: 110 + dx - 24,
        top: 110 + dy - 10,
        child: SizedBox(
          width: 48,
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ),
      );
    });
  }
}

class _WheelPainter extends CustomPainter {
  const _WheelPainter({required this.segmentCount});

  final int segmentCount;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 8;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = AppColors.background;

    final int count = segmentCount.clamp(4, 12);
    final double sweep = (2 * pi) / count;
    double start = -pi / 2;

    for (int i = 0; i < count; i++) {
      paint.color = i.isEven ? AppColors.primary : const Color(0xFFFFA04A);
      canvas.drawArc(rect, start, sweep, true, paint);
      canvas.drawArc(rect, start, sweep, true, borderPaint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) {
    return oldDelegate.segmentCount != segmentCount;
  }
}

class _SpinSearchBar extends StatelessWidget {
  const _SpinSearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.primary, width: 1.3),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.search_rounded, color: AppColors.primary, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'Search for coffee shops...',
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
