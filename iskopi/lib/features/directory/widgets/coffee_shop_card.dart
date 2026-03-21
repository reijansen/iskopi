import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/custom_outline_button.dart';

class CoffeeShopCard extends StatelessWidget {
  const CoffeeShopCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.tags,
    this.description,
    required this.onViewShop,
  });

  final String imagePath;
  final String name;
  final List<String> tags;
  final String? description;
  final VoidCallback onViewShop;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              height: AppSpacing.cardImageHeight,
              width: double.infinity,
              child: Image.asset(
                imagePath,
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
                          size: AppSpacing.xxl + AppSpacing.sm,
                        ),
                      );
                    },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(name, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: tags.map(_buildTag).toList(),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(description!, style: AppTextStyles.bodySmall),
          ],
          const SizedBox(height: AppSpacing.md),
          CustomOutlineButton(
            text: 'View shop',
            icon: Icons.arrow_forward_rounded,
            onPressed: onViewShop,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        tag,
        style: AppTextStyles.label.copyWith(color: AppColors.primary),
      ),
    );
  }
}
