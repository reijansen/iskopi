import '../../core/utils/json_loader.dart';
import '../models/coffee_shop.dart';

class CoffeeShopRepository {
  CoffeeShopRepository({JsonLoader? jsonLoader})
    : _jsonLoader = jsonLoader ?? const JsonLoader();

  static const String _shopsAssetPath = 'assets/data/coffee_shops.json';

  final JsonLoader _jsonLoader;

  Future<List<CoffeeShop>> getAllShops() async {
    final List<dynamic> rawList = await _jsonLoader.loadJsonList(
      _shopsAssetPath,
    );

    return rawList
        .map(
          (dynamic item) => CoffeeShop.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
