import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../features/directory/widgets/coffee_shop_card.dart';
import '../../../features/home/widgets/home_menu_overlay.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../shared/widgets/custom_filled_button.dart';
import '../../../shared/widgets/custom_outline_button.dart';
import '../../../shared/widgets/custom_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  void _openMenuOverlay() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'menu',
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder:
          (
            BuildContext dialogContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return HomeMenuOverlay(
              onClose: () => Navigator.of(dialogContext).pop(),
              onHome: () => _navigateFromOverlay(AppRoutes.home, dialogContext),
              onAbout: () =>
                  _navigateFromOverlay(AppRoutes.about, dialogContext),
              onDirectory: () =>
                  _navigateFromOverlay(AppRoutes.directory, dialogContext),
              onCantDecide: () =>
                  _navigateFromOverlay(AppRoutes.spin, dialogContext),
            );
          },
    );
  }

  void _navigateFromOverlay(String route, BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();

    if (route == AppRoutes.home) {
      return;
    }

    Navigator.of(context).pushNamed(route);
  }

  void _onNavTap(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    final String route = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.directory,
      2 => AppRoutes.spin,
      3 => AppRoutes.about,
      _ => AppRoutes.home,
    };

    if (route != AppRoutes.home) {
      Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'iskopi components',
        actions: <Widget>[
          IconButton(
            onPressed: _openMenuOverlay,
            icon: const Icon(Icons.menu_rounded),
            color: AppColors.textPrimary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CustomSearchBar(),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: <Widget>[
                CustomFilledButton(
                  text: 'Primary Action',
                  icon: Icons.local_cafe_rounded,
                  onPressed: () {},
                ),
                CustomOutlineButton(
                  text: 'Secondary',
                  icon: Icons.explore_rounded,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            CoffeeShopCard(
              imagePath: 'assets/images/demo_shop.jpg',
              name: 'Kopi Sudut Kampus',
              tags: const <String>['WiFi', 'Student-friendly', 'Affordable'],
              description:
                  'Sample preview card for the shared design system in phase 2.',
              onViewShop: () =>
                  Navigator.of(context).pushNamed(AppRoutes.shopDetails),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
