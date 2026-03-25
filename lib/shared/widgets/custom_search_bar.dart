import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.hintText = 'Search coffee shops',
    this.onChanged,
    this.controller,
    this.height = AppSpacing.searchBarHeight,
    this.textStyle,
    this.hintStyle,
    this.iconSize = 24,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final double height;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: textStyle ?? AppTextStyles.body,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: hintStyle ?? AppTextStyles.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
