import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../features/home/widgets/home_menu_overlay.dart';
import '../../../shared/widgets/brand_top_bar.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../widgets/decorative_about_image.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String _upperRightAsset = 'assets/images/about/coffee_drink.png';
  static const String _middleRightAsset = 'assets/images/about/coffee_beans.png';
  static const String _lowerLeftAsset = 'assets/images/about/iced_drink_hand.png';

  static const String _paragraphOne =
      'IsKopi was created to make coffee shop discovery around the '
      'University of the Philippines Visayas simpler, faster, and more '
      'accessible. Recognizing that information about nearby cafes is often '
      'scattered across different platforms, we built a lightweight mobile '
      'directory that centralizes essential details such as operating hours, '
      'price range, and amenities into one clean, easy-to-use interface.';

  static const String _paragraphTwo =
      'Developed using Flutter with a focus on simplicity and offline '
      'usability, IsKopi prioritizes clarity, practical filters, and intuitive '
      'navigation over unnecessary features, providing students and '
      'campus-goers with a reliable tool for everyday coffee '
      'decisions.';

  void _onBottomNavTap(BuildContext context, int index) {
    final String targetRoute = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.directory,
      2 => AppRoutes.spin,
      3 => AppRoutes.about,
      _ => AppRoutes.about,
    };

    if (targetRoute == AppRoutes.about) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  void _openMenuOverlay(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'about_menu',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (
        BuildContext dialogContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return HomeMenuOverlay(
          activeItem: HomeMenuItem.about,
          onClose: () => Navigator.of(dialogContext).pop(),
          onHome: () => _navigateFromOverlay(context, dialogContext, AppRoutes.home),
          onAbout: () => Navigator.of(dialogContext).pop(),
          onDirectory: () =>
              _navigateFromOverlay(context, dialogContext, AppRoutes.directory),
          onCantDecide: () =>
              _navigateFromOverlay(context, dialogContext, AppRoutes.spin),
        );
      },
      transitionBuilder: (
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

  void _navigateFromOverlay(
    BuildContext context,
    BuildContext dialogContext,
    String route,
  ) {
    Navigator.of(dialogContext).pop();
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BrandTopBar(
                onBrandTap: () => Navigator.of(context).pushReplacementNamed(
                  AppRoutes.home,
                ),
                onMenuTap: () => _openMenuOverlay(context),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'About IsKopi',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 36 / 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _paragraphOne,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const DecorativeAboutImage(
                    assetPath: _upperRightAsset,
                    placeholderLabel: 'Coffee drink',
                    width: 108,
                    height: 92,
                    borderRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _paragraphTwo,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const DecorativeAboutImage(
                    assetPath: _middleRightAsset,
                    placeholderLabel: 'Coffee beans',
                    width: 142,
                    height: 270,
                    borderRadius: 0,
                    fit: BoxFit.contain,
                    clipToRadius: false,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const DecorativeAboutImage(
                    assetPath: _lowerLeftAsset,
                    placeholderLabel: 'Iced drink',
                    width: 132,
                    height: 178,
                    borderRadius: 24,
                    flipHorizontally: true,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Developed with caffeine by:',
                            textAlign: TextAlign.right,
                            softWrap: true,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'John Romson Erazo\nRei Jansen Buerom',
                            textAlign: TextAlign.right,
                            softWrap: true,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (int index) => _onBottomNavTap(context, index),
      ),
    );
  }
}
