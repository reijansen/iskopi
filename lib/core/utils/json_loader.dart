import 'dart:convert';

import 'package:flutter/services.dart';

class JsonLoader {
  const JsonLoader();

  Future<dynamic> loadJson(String assetPath) async {
    final String data = await rootBundle.loadString(assetPath);
    return jsonDecode(data);
  }

  Future<List<dynamic>> loadJsonList(String assetPath) async {
    final dynamic decoded = await loadJson(assetPath);

    if (decoded is List<dynamic>) {
      return decoded;
    }

    throw const FormatException(
      'Expected a JSON list at the provided asset path.',
    );
  }
}
