import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeMenuOverlay extends StatelessWidget {
  const HomeMenuOverlay({
    super.key,
    required this.onClose,
    required this.onHome,
    required this.onAbout,
    required this.onDirectory,
    required this.onCantDecide,
  });

  final VoidCallback onClose;
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onDirectory;
  final VoidCallback onCantDecide;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: AppColors.overlay,
          child: SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 260,
                  margin: const EdgeInsets.all(AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Menu', style: AppTextStyles.title),
                          ),
                          IconButton(
                            onPressed: onClose,
                            icon: const Icon(Icons.close_rounded),
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _MenuItem(label: 'Home', onTap: onHome),
                      _MenuItem(label: 'About', onTap: onAbout),
                      _MenuItem(label: 'Directory', onTap: onDirectory),
                      _MenuItem(label: "Can't Decide", onTap: onCantDecide),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Text(label, style: AppTextStyles.body),
      ),
    );
  }
}
