import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();
  static const String _selectedSpinShopIdsKey = 'selected_spin_shop_ids';

  Future<void> saveStringList(String key, List<String> values) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values);
  }

  Future<List<String>> getStringList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? <String>[];
  }

  Future<void> saveSelectedShopIds(List<String> ids) {
    return saveStringList(_selectedSpinShopIdsKey, ids);
  }

  Future<List<String>> getSelectedShopIds() {
    return getStringList(_selectedSpinShopIdsKey);
  }
}
