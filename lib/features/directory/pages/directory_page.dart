import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/shop_tags.dart';
import '../../../data/models/coffee_shop.dart';
import '../../../data/repositories/coffee_shop_repository.dart';
import '../../../features/home/widgets/home_menu_overlay.dart';
import '../../../shared/widgets/brand_top_bar.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../shared/widgets/custom_search_bar.dart';
import '../widgets/coffee_shop_card.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final CoffeeShopRepository _repository = CoffeeShopRepository();
  final TextEditingController _searchController = TextEditingController();

  List<CoffeeShop> _allShops = <CoffeeShop>[];
  List<CoffeeShop> _filteredShops = <CoffeeShop>[];
  String _searchQuery = '';
  String? _selectedFilter;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadShops() async {
    try {
      final List<CoffeeShop> shops = await _repository.getAllShops();

      if (!mounted) {
        return;
      }

      setState(() {
        _allShops = shops;
        _isLoading = false;
      });
      _applyFilters();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Unable to load coffee shops right now.';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  void _onFilterSelected(String filterKey) {
    setState(() {
      _selectedFilter = _selectedFilter == filterKey ? null : filterKey;
    });
    _applyFilters();
  }

  void _applyFilters() {
    final List<CoffeeShop> next = _allShops.where((CoffeeShop shop) {
      final bool matchesSearch =
          _searchQuery.isEmpty ||
          shop.name.toLowerCase().contains(_searchQuery) ||
          shop.shortTags.any(
            (String tag) => tag.toLowerCase().contains(_searchQuery),
          );

      final bool matchesFilter =
          _selectedFilter == null ||
          shop.shortTags.contains(_selectedFilter);

      return matchesSearch && matchesFilter;
    }).toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _filteredShops = next;
    });
  }

  void _onBottomNavTap(int index) {
    final String targetRoute = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.directory,
      2 => AppRoutes.spin,
      3 => AppRoutes.about,
      _ => AppRoutes.directory,
    };

    if (targetRoute == AppRoutes.directory) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  void _openShopDetails(CoffeeShop shop) {
    Navigator.of(context).pushNamed(AppRoutes.shopDetails, arguments: shop);
  }

  void _openMenuOverlay() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'directory_menu',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder:
          (
            BuildContext dialogContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return HomeMenuOverlay(
              activeItem: HomeMenuItem.directory,
              onClose: () => Navigator.of(dialogContext).pop(),
              onHome: () => _navigateFromOverlay(dialogContext, AppRoutes.home),
              onAbout: () =>
                  _navigateFromOverlay(dialogContext, AppRoutes.about),
              onDirectory: () => Navigator.of(dialogContext).pop(),
              onCantDecide: () =>
                  _navigateFromOverlay(dialogContext, AppRoutes.spin),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final CurvedAnimation curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curve,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, -0.03),
                  end: Offset.zero,
                ).animate(curve),
                child: child,
              ),
            );
          },
    );
  }

  void _navigateFromOverlay(BuildContext dialogContext, String route) {
    Navigator.of(dialogContext).pop();
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          0,
        ),
        child: Column(
          children: <Widget>[
            BrandTopBar(
              onBrandTap: () =>
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home),
              onMenuTap: _openMenuOverlay,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: AppSpacing.sm),
            CustomSearchBar(
              controller: _searchController,
              hintText: 'Search for coffee shops..',
              onChanged: _onSearchChanged,
              height: 34,
              iconSize: 18,
              textStyle: AppTextStyles.bodySmall.copyWith(fontSize: 12),
              hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 11),
            ),
            const SizedBox(height: AppSpacing.xs),
            _FilterChips(
              selectedFilter: _selectedFilter,
              onSelected: _onFilterSelected,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: _buildDirectoryContent()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildDirectoryContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_filteredShops.isEmpty) {
      return Center(
        child: Text(
          'No coffee shops match your search.',
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      itemCount: _filteredShops.length,
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (BuildContext context, int index) {
        final CoffeeShop shop = _filteredShops[index];

        return CoffeeShopCard(
          imagePath: shop.image,
          name: shop.name,
          tags: shop.shortTags,
          description: shop.shortDescription,
          onTap: () => _openShopDetails(shop),
          onViewShop: () => _openShopDetails(shop),
        );
      },
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selectedFilter, required this.onSelected});

  final String? selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: ShopTags.allowed
            .map((String filterKey) => _chip(label: filterKey, filterKey: filterKey))
            .toList(),
      ),
    );
  }

  Widget _chip({
    required String label,
    required String filterKey,
  }) {
    final bool isActive = selectedFilter == filterKey;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: InkWell(
        onTap: () => onSelected(filterKey),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primarySoft : const Color(0xFFE9DFD4),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                _iconForFilter(filterKey),
                size: 12,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 3),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  fontSize: 10,
                  height: 1,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForFilter(String filterKey) {
    return switch (filterKey) {
      'aircon' => Icons.ac_unit_rounded,
      'alfresco' => Icons.deck_rounded,
      'budget' => Icons.wallet_rounded,
      'camping' => Icons.park_rounded,
      'group-friendly' => Icons.groups_rounded,
      'meals' => Icons.restaurant_rounded,
      'minimalist' => Icons.crop_square_rounded,
      'outlets' => Icons.power_rounded,
      'quick-stop' => Icons.flash_on_rounded,
      _ => Icons.local_offer_rounded,
    };
  }
}
