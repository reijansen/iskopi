import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/coffee_shop.dart';
import '../../../data/repositories/coffee_shop_repository.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../widgets/detail_section.dart';
import '../widgets/shop_hero_image.dart';
import '../widgets/shop_details_top_bar.dart';

class ShopDetailsPage extends StatefulWidget {
  const ShopDetailsPage({super.key, this.argument});

  final Object? argument;

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  late final Future<CoffeeShop?> _shopFuture;
  final CoffeeShopRepository _repository = CoffeeShopRepository();

  @override
  void initState() {
    super.initState();
    _shopFuture = _resolveShop(widget.argument);
  }

  Future<CoffeeShop?> _resolveShop(Object? argument) async {
    if (argument is CoffeeShop) {
      return argument;
    }

    if (argument is String && argument.isNotEmpty) {
      final List<CoffeeShop> shops = await _repository.getAllShops();
      for (final CoffeeShop shop in shops) {
        if (shop.id == argument) {
          return shop;
        }
      }
    }

    return null;
  }

  void _onBottomNavTap(int index) {
    final String targetRoute = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.directory,
      2 => AppRoutes.spin,
      3 => AppRoutes.about,
      _ => AppRoutes.directory,
    };

    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoffeeShop?>(
      future: _shopFuture,
      builder: (BuildContext context, AsyncSnapshot<CoffeeShop?> snapshot) {
        final CoffeeShop? shop = snapshot.data;

        return Scaffold(
          body: SafeArea(child: _buildBody(snapshot, shop)),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 1,
            onTap: _onBottomNavTap,
          ),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<CoffeeShop?> snapshot, CoffeeShop? shop) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (shop == null) {
      return Center(
        child: Text(
          'Unable to load this shop details.',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
          child: ShopDetailsTopBar(
            title: shop.name,
            onBackTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, AppSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShopHeroImage(imagePath: shop.image),
                const SizedBox(height: 10),
                DetailSection(
                  icon: Icons.location_on_rounded,
                  label: shop.name,
                  value: shop.location,
                ),
                DetailSection(
                  icon: Icons.access_time_rounded,
                  label: 'Operating Hours',
                  value: shop.hours,
                ),
                DetailSection(
                  icon: Icons.paid_rounded,
                  label: 'Price Range',
                  value: shop.priceRange,
                ),
                DetailSection(
                  icon: Icons.near_me_rounded,
                  label: 'How to get there',
                  value: _normalizeText(shop.directions),
                ),
                DetailSection(
                  icon: Icons.info_rounded,
                  label: 'Other Information',
                  value: _normalizeToMultiline(shop.otherInfo),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _normalizeText(String value) => value.trim();

  String _normalizeToMultiline(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    if (trimmed.contains(',')) {
      return trimmed.split(',').map((String s) => s.trim()).join('\n');
    }

    return trimmed;
  }
}
