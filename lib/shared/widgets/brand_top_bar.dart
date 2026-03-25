import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class BrandTopBar extends StatelessWidget {
  const BrandTopBar({
    super.key,
    required this.onMenuTap,
    this.onBrandTap,
    this.title = 'IsKopi',
  });

  final VoidCallback onMenuTap;
  final VoidCallback? onBrandTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: onBrandTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            child: Text(
              title,
              style: AppTextStyles.title.copyWith(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onMenuTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.menu_rounded, color: AppColors.primary, size: 24),
          ),
        ),
      ],
    );
  }
}
