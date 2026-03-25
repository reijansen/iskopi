import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_radius.dart';
import 'core/constants/app_spacing.dart';
import 'core/constants/app_text_styles.dart';
import 'features/about/pages/about_page.dart';
import 'features/directory/pages/directory_page.dart';
import 'features/home/pages/home_page.dart';
import 'features/shop_details/pages/shop_details_page.dart';
import 'features/spin/pages/spin_page.dart';

class AppRoutes {
  static const String root = '/';
  static const String home = '/home';
  static const String directory = '/directory';
  static const String spin = '/spin';
  static const String shopDetails = '/shop-details';
  static const String about = '/about';
}

class IskopiApp extends StatelessWidget {
  const IskopiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iskopi',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: AppRoutes.root,
      routes: {
        AppRoutes.root: (context) => const HomePage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.directory: (context) => const DirectoryPage(),
        AppRoutes.spin: (context) => const SpinPage(),
        AppRoutes.about: (context) => const AboutPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == AppRoutes.shopDetails) {
          return MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                ShopDetailsPage(argument: settings.arguments),
            settings: settings,
          );
        }

        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              const _RoutePlaceholderPage(title: 'page not found'),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: Colors.red.shade700,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeight),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.bodySmall,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}

class _RoutePlaceholderPage extends StatelessWidget {
  const _RoutePlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
