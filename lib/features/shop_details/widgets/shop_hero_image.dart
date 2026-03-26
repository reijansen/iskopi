import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/resilient_asset_image.dart';

class ShopHeroImage extends StatelessWidget {
  const ShopHeroImage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: 156,
        width: double.infinity,
        child: ResilientAssetImage(
          assetPath: imagePath,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return Container(
                  color: AppColors.primarySoft,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_cafe_rounded,
                    color: AppColors.primary,
                    size: AppSpacing.xxl + AppSpacing.sm,
                  ),
                );
              },
        ),
      ),
    );
  }
}
