import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_BottomNavItemData> _items = <_BottomNavItemData>[
    _BottomNavItemData(label: 'Home', icon: Icons.home_rounded),
    _BottomNavItemData(label: 'Directory', icon: Icons.storefront_rounded),
    _BottomNavItemData(label: 'Spin', icon: Icons.casino_rounded),
    _BottomNavItemData(label: 'About', icon: Icons.info_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 1, AppSpacing.md, 1),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadowSoft,
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: List<Widget>.generate(_items.length, (int index) {
              final _BottomNavItemData item = _items[index];
              final bool isActive = index == currentIndex;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primarySoft
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 16,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          item.label,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 9,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItemData {
  const _BottomNavItemData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
