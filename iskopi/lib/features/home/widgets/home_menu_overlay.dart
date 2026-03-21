import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

enum HomeMenuItem { home, about, directory, cantDecide }

class HomeMenuOverlay extends StatelessWidget {
  const HomeMenuOverlay({
    super.key,
    required this.onClose,
    required this.onHome,
    required this.onAbout,
    required this.onDirectory,
    required this.onCantDecide,
    this.activeItem = HomeMenuItem.home,
  });

  final VoidCallback onClose;
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onDirectory;
  final VoidCallback onCantDecide;
  final HomeMenuItem activeItem;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              child: Container(color: AppColors.overlay),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: AppSpacing.xxl * 8,
                margin: const EdgeInsets.all(AppSpacing.lg),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: AppSpacing.xl,
                      offset: Offset(0, AppSpacing.md),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: onClose,
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.textPrimary,
                        splashRadius: AppSpacing.lg,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _MenuItem(
                      label: 'HOME',
                      isActive: activeItem == HomeMenuItem.home,
                      onTap: onHome,
                    ),
                    _MenuItem(
                      label: 'ABOUT',
                      isActive: activeItem == HomeMenuItem.about,
                      onTap: onAbout,
                    ),
                    _MenuItem(
                      label: 'DIRECTORY',
                      isActive: activeItem == HomeMenuItem.directory,
                      onTap: onDirectory,
                    ),
                    _MenuItem(
                      label: 'CAN\'T DECIDE',
                      isActive: activeItem == HomeMenuItem.cantDecide,
                      onTap: onCantDecide,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.label,
    required this.onTap,
    required this.isActive,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Text(
            label,
            style: AppTextStyles.title.copyWith(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
