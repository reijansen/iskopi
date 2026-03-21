import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class SpinPage extends StatelessWidget {
  const SpinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Can\'t Decide')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'spin page',
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
