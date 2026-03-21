import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/coffee_shop.dart';

class ShopDetailsPage extends StatelessWidget {
  const ShopDetailsPage({super.key, this.argument});

  final Object? argument;

  @override
  Widget build(BuildContext context) {
    final _ShopDetailsPayload payload = _ShopDetailsPayload.from(argument);

    return Scaffold(
      appBar: AppBar(title: const Text('Shop Details')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Selected Shop', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            Text(payload.displayName, style: AppTextStyles.body),
            if (payload.shopId != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text('ID: ${payload.shopId}', style: AppTextStyles.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShopDetailsPayload {
  const _ShopDetailsPayload({required this.displayName, this.shopId});

  final String displayName;
  final String? shopId;

  factory _ShopDetailsPayload.from(Object? argument) {
    if (argument is CoffeeShop) {
      return _ShopDetailsPayload(
        displayName: argument.name,
        shopId: argument.id,
      );
    }

    if (argument is String) {
      return _ShopDetailsPayload(displayName: argument, shopId: argument);
    }

    return const _ShopDetailsPayload(displayName: 'No shop selected');
  }
}
