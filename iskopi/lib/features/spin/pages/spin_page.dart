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
import '../widgets/spin_result_modal.dart';
import '../widgets/spin_wheel_widget.dart';

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

  void _showResultModal() {
    final result = _provider.latestResult;
    if (result == null) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.overlay,
      builder: (BuildContext dialogContext) {
        return SpinResultModal(
          shop: result,
          onClose: () => Navigator.of(dialogContext).pop(),
          onViewShop: () {
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pushNamed(
              AppRoutes.shopDetails,
              arguments: result,
            );
          },
        );
      },
    );
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
                  Center(
                    child: SpinWheelWidget(
                      shops: _provider.selectedShops,
                      spinRequestId: _provider.spinRequestId,
                      targetIndex: _provider.pendingTargetIndex,
                      onSpinEnd: (int landedIndex) {
                        _provider.finishSpin(landedIndex: landedIndex);
                        if (mounted) {
                          _showResultModal();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: _provider.canSpin
                            ? _provider.startSpin
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
                  const SizedBox(height: AppSpacing.xs),
                  if (_provider.selectedCount < 2)
                    Center(
                      child: Text(
                        'Pick at least 2 shops to spin.',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  if (_provider.selectedCount < 2)
                    const SizedBox(height: AppSpacing.sm),
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
          onToggle: _provider.isSpinning
              ? null
              : () {
            _provider.toggleShopSelection(shop.id);
          },
        );
      },
    );
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
