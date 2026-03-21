import 'package:flutter/foundation.dart';
import 'dart:math';

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
  bool _isSpinning = false;
  String? _errorMessage;
  CoffeeShop? _latestResult;
  int _spinRequestId = 0;
  int? _pendingTargetIndex;

  bool get isLoading => _isLoading;
  bool get isSpinning => _isSpinning;
  String? get errorMessage => _errorMessage;
  String get query => _query;
  int get selectedCount => _selectedShopIds.length;
  bool get canSpin => _selectedShopIds.length >= 2 && !_isSpinning;
  CoffeeShop? get latestResult => _latestResult;
  int get spinRequestId => _spinRequestId;
  int? get pendingTargetIndex => _pendingTargetIndex;

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
    if (_isSpinning) {
      return;
    }

    if (_selectedShopIds.contains(shopId)) {
      _selectedShopIds.remove(shopId);
    } else {
      _selectedShopIds.add(shopId);
    }

    if (_latestResult != null && !_selectedShopIds.contains(_latestResult!.id)) {
      _latestResult = null;
    }

    notifyListeners();
    await _storageService.saveSelectedShopIds(_selectedShopIds.toList());
  }

  Future<void> removeFromPool(String shopId) async {
    if (_isSpinning) {
      return;
    }

    if (_selectedShopIds.remove(shopId)) {
      if (_latestResult != null && _latestResult!.id == shopId) {
        _latestResult = null;
      }
      notifyListeners();
      await _storageService.saveSelectedShopIds(_selectedShopIds.toList());
    }
  }

  void startSpin() {
    if (!canSpin) {
      return;
    }

    final List<CoffeeShop> shops = selectedShops;
    if (shops.length < 2) {
      return;
    }

    _latestResult = null;
    _pendingTargetIndex = Random().nextInt(shops.length);
    _isSpinning = true;
    _spinRequestId += 1;
    notifyListeners();
  }

  void finishSpin({required int landedIndex}) {
    final List<CoffeeShop> shops = selectedShops;
    if (shops.isEmpty) {
      _latestResult = null;
      _isSpinning = false;
      _pendingTargetIndex = null;
      notifyListeners();
      return;
    }

    final int safeIndex = landedIndex.clamp(0, shops.length - 1);
    _latestResult = shops[safeIndex];
    _isSpinning = false;
    _pendingTargetIndex = null;
    notifyListeners();
  }

  void clearLatestResult() {
    if (_latestResult == null) {
      return;
    }
    _latestResult = null;
    notifyListeners();
  }
}
