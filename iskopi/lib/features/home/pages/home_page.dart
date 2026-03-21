import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/custom_outline_button.dart';
import '../widgets/home_mascot_illustration.dart';
import '../widgets/home_menu_overlay.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _topMascotAsset = 'assets/images/mascots/top_mascot.png';
  static const String _bottomMascotAsset =
      'assets/images/mascots/bottom_mascot.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isCompact = constraints.maxHeight < 760;

            if (isCompact) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _HomeContent(
                  onMenuTap: () => _openMenuOverlay(context),
                  topMascotHeight: AppSpacing.xxl * 3.2,
                  bottomMascotHeight: AppSpacing.xxl * 2.2,
                  useSpacer: false,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _HomeContent(
                onMenuTap: () => _openMenuOverlay(context),
                topMascotHeight: AppSpacing.xxl * 4,
                bottomMascotHeight: AppSpacing.xxl * 3,
                useSpacer: true,
              ),
            );
          },
        ),
      ),
    );
  }

  void _openMenuOverlay(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'home_menu',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder:
          (
            BuildContext dialogContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return HomeMenuOverlay(
              activeItem: HomeMenuItem.home,
              onClose: () => Navigator.of(dialogContext).pop(),
              onHome: () => Navigator.of(dialogContext).pop(),
              onAbout: () => _navigateFromOverlay(
                context: context,
                dialogContext: dialogContext,
                route: AppRoutes.about,
              ),
              onDirectory: () => _navigateFromOverlay(
                context: context,
                dialogContext: dialogContext,
                route: AppRoutes.directory,
              ),
              onCantDecide: () => _navigateFromOverlay(
                context: context,
                dialogContext: dialogContext,
                route: AppRoutes.spin,
              ),
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

  void _navigateFromOverlay({
    required BuildContext context,
    required BuildContext dialogContext,
    required String route,
  }) {
    Navigator.of(dialogContext).pop();
    Navigator.of(context).pushNamed(route);
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.onMenuTap,
    required this.topMascotHeight,
    required this.bottomMascotHeight,
    required this.useSpacer,
  });

  final VoidCallback onMenuTap;
  final double topMascotHeight;
  final double bottomMascotHeight;
  final bool useSpacer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: AppSpacing.md),
        _HomeHeader(onMenuTap: onMenuTap),
        const SizedBox(height: AppSpacing.sm),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: AppSpacing.lg),
        HomeMascotIllustration(
          assetPath: HomePage._topMascotAsset,
          height: topMascotHeight,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'What coffee are we drinking today?',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: AppSpacing.xl + AppSpacing.md,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: CustomOutlineButton(
            text: 'DIRECTORY',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.directory),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: CustomOutlineButton(
            text: 'CAN\'T DECIDE',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.spin),
          ),
        ),
        if (useSpacer)
          const Spacer()
        else
          const SizedBox(height: AppSpacing.xl),
        HomeMascotIllustration(
          assetPath: HomePage._bottomMascotAsset,
          height: bottomMascotHeight,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'IsKopi',
          style: AppTextStyles.headingMedium.copyWith(
            fontSize: AppSpacing.xl + AppSpacing.md,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: onMenuTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Icon(Icons.menu_rounded, color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
