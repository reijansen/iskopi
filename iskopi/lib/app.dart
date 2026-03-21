import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'features/home/pages/home_page.dart';

class AppRoutes {
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
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.directory: (context) =>
            const _RoutePlaceholderPage(title: 'directory page'),
        AppRoutes.spin: (context) =>
            const _RoutePlaceholderPage(title: 'spin page'),
        AppRoutes.shopDetails: (context) =>
            const _RoutePlaceholderPage(title: 'shop details page'),
        AppRoutes.about: (context) =>
            const _RoutePlaceholderPage(title: 'about page'),
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
