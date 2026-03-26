import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/shop_tags.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/resilient_asset_image.dart';

class CoffeeShopCard extends StatelessWidget {
  const CoffeeShopCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.tags,
    this.description,
    required this.onViewShop,
    this.onTap,
  });

  final String imagePath;
  final String name;
  final List<String> tags;
  final String? description;
  final VoidCallback onViewShop;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final List<String> displayTags = tags
        .where(ShopTags.allowed.contains)
        .toSet()
        .take(3)
        .toList();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppCard(
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 10,
            spreadRadius: 0.4,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            spreadRadius: -6,
            offset: Offset(0, 10),
          ),
        ],
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                height: 96,
                width: double.infinity,
                child: ResilientAssetImage(
                  assetPath: imagePath,
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              name,
              style: AppTextStyles.title.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              height: 22,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: displayTags.length,
                separatorBuilder:
                    (BuildContext context, int index) =>
                        const SizedBox(width: 6),
                itemBuilder: (BuildContext context, int index) {
                  final String tag = displayTags[index];
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 9.5,
                        height: 1.0,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (description != null && description!.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                description!,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            _SmallFilledActionButton(text: 'View Shop', onPressed: onViewShop),
          ],
        ),
      ),
    );
  }

}

class _SmallFilledActionButton extends StatelessWidget {
  const _SmallFilledActionButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          textStyle: AppTextStyles.label.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
          elevation: 0,
        ),
        child: Text(text),
      ),
    );
  }
}
