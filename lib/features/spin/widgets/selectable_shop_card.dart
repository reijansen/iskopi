import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/coffee_shop.dart';
import '../../../shared/widgets/resilient_asset_image.dart';

class SelectableShopCard extends StatelessWidget {
  const SelectableShopCard({
    required this.shop,
    required this.isSelected,
    required this.onToggle,
    super.key,
  });

  final CoffeeShop shop;
  final bool isSelected;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onToggle == null;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border, width: 0.8),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadowSoft,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SizedBox(
                    width: 120,
                    height: 88,
                    child: ResilientAssetImage(
                      assetPath: shop.image,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) {
                            return Container(
                              color: AppColors.primarySoft,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.local_cafe_rounded,
                                color: AppColors.primary,
                                size: AppSpacing.xl,
                              ),
                            );
                          },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SizedBox(
                    height: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          shop.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 30 / 2,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        ...shop.shortTags.take(3).map(
                          (String tag) => Text(
                            _formatTag(tag),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.primary,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: -10,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDisabled
                    ? AppColors.border
                    : (isSelected
                          ? const Color(0xFFFF3B4B)
                          : AppColors.primary),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.close_rounded : Icons.add_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
        if (isDisabled)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatTag(String rawTag) {
    if (rawTag.isEmpty) {
      return rawTag;
    }

    final String first = rawTag[0].toUpperCase();
    if (rawTag.length == 1) {
      return first;
    }
    return '$first${rawTag.substring(1)}';
  }
}
