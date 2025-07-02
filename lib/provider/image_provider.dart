import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePreloadProvider extends ChangeNotifier {
  final Map<String, Uint8List> _images = {};
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Uint8List? getImage(String key) => _images[key];

  Future<void> preloadImages({
    required List<String> paths,
    required Future<Uint8List> Function(String path) decryptFn,
  }) async {
    for (final path in paths) {
      final key = path.split('/').last;
      if (!_images.containsKey(key)) {
        final decrypted = await decryptFn(path);
        _images[key] = decrypted;
      }
    }
    _isLoaded = true;
    notifyListeners();
  }
}
