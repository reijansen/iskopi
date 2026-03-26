import 'package:flutter/material.dart';

class ResilientAssetImage extends StatelessWidget {
  const ResilientAssetImage({
    super.key,
    required this.assetPath,
    required this.fit,
    required this.errorBuilder,
  });

  final String assetPath;
  final BoxFit fit;
  final ImageErrorWidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return _buildImage(assetPath, allowFallback: true);
  }

  Widget _buildImage(String path, {required bool allowFallback}) {
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        if (allowFallback) {
          final String? fallbackPath = _fallbackAssetPath(path);
          if (fallbackPath != null && fallbackPath != path) {
            return _buildImage(fallbackPath, allowFallback: false);
          }
        }

        return errorBuilder(context, error, stackTrace);
      },
    );
  }

  String? _fallbackAssetPath(String path) {
    const String prefixed = 'assets/';
    if (path.startsWith(prefixed) && path.length > prefixed.length) {
      return path.substring(prefixed.length);
    }
    return null;
  }
}
