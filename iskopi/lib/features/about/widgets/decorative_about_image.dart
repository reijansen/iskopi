import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_text_styles.dart';

class DecorativeAboutImage extends StatelessWidget {
  const DecorativeAboutImage({
    super.key,
    required this.assetPath,
    required this.placeholderLabel,
    this.width = 120,
    this.height = 90,
    this.borderRadius = AppRadius.md,
    this.flipHorizontally = false,
    this.fit = BoxFit.cover,
    this.clipToRadius = true,
  });

  final String assetPath;
  final String placeholderLabel;
  final double width;
  final double height;
  final double borderRadius;
  final bool flipHorizontally;
  final BoxFit fit;
  final bool clipToRadius;

  @override
  Widget build(BuildContext context) {
    Widget image = SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        assetPath,
        fit: fit,
        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) {
          return Container(
            color: AppColors.primarySoft,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Text(
              placeholderLabel,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );

    if (clipToRadius) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
    }

    if (flipHorizontally) {
      image = Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
        child: image,
      );
    }

    return image;
  }
}
