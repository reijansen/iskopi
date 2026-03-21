import 'package:flutter/foundation.dart';

import '../../../data/models/coffee_shop.dart';
import '../../../data/repositories/coffee_shop_repository.dart';
import '../../../data/services/local_storage_service.dart';

class SpinProvider extends ChangeNotifier {
  SpinProvider({
    CoffeeShopRepository? repository,
    LocalStorageService? storageService,
  }) : _repository = repository ?? CoffeeShopRepository(),
       _storageService = storageService ?? LocalStorageService.instance;

  final CoffeeShopRepository _repository;
  final LocalStorageService _storageService;

  List<CoffeeShop> _allShops = <CoffeeShop>[];
  Set<String> _selectedShopIds = <String>{};
  String _query = '';
  bool _isLoading = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get query => _query;
  int get selectedCount => _selectedShopIds.length;
  bool get canSpin => _selectedShopIds.length >= 2;

  List<CoffeeShop> get selectedShops {
    return _allShops
        .where((CoffeeShop shop) => _selectedShopIds.contains(shop.id))
        .toList();
  }

  List<CoffeeShop> get filteredShops {
    final String keyword = _query.trim().toLowerCase();
    if (keyword.isEmpty) {
      return _allShops;
    }

    return _allShops.where((CoffeeShop shop) {
      final String name = shop.name.toLowerCase();
      final String location = shop.location.toLowerCase();
      final String tags = shop.shortTags.join(' ').toLowerCase();
      return name.contains(keyword) ||
          location.contains(keyword) ||
          tags.contains(keyword);
    }).toList();
  }

  bool isSelected(String shopId) => _selectedShopIds.contains(shopId);

  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<CoffeeShop> shops = await _repository.getAllShops();
      final List<String> savedIds = await _storageService.getSelectedShopIds();
      final Set<String> validIds = shops.map((CoffeeShop e) => e.id).toSet();

      _allShops = shops;
      _selectedShopIds = savedIds
          .where((String id) => validIds.contains(id))
          .toSet();
    } catch (_) {
      _errorMessage = 'Unable to load coffee shops.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> toggleShopSelection(String shopId) async {
    if (_selectedShopIds.contains(shopId)) {
      _selectedShopIds.remove(shopId);
    } else {
      _selectedShopIds.add(shopId);
    }
    notifyListeners();
    await _storageService.saveSelectedShopIds(_selectedShopIds.toList());
  }

  Future<void> removeFromPool(String shopId) async {
    if (_selectedShopIds.remove(shopId)) {
      notifyListeners();
      await _storageService.saveSelectedShopIds(_selectedShopIds.toList());
    }
  }
}
