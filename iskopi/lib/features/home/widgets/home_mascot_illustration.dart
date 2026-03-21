import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

class HomeMascotIllustration extends StatelessWidget {
  const HomeMascotIllustration({
    super.key,
    required this.assetPath,
    this.height = AppSpacing.xxl * 4,
  });

  final String assetPath;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );
  }
}
