// lib/screens/helper/encrypted_asset_loader.dart
import 'dart:typed_data';
import 'package:flutter/services.dart';

class EncryptedAssetLoader {
  static final Map<String, Uint8List> _cache = {};

  static Future<Uint8List> loadDecrypted(String assetPath) async {
    if (_cache.containsKey(assetPath)) return _cache[assetPath]!;

    try {
      final ByteData bytes = await rootBundle.load(assetPath);
      final Uint8List encrypted = bytes.buffer.asUint8List();
      final Uint8List decrypted = Uint8List(encrypted.length);

      // Fixed decryption: XOR with 0xAA
      for (int i = 0; i < encrypted.length; i++) {
        decrypted[i] = encrypted[i] ^ 0xAA;
      }

      _cache[assetPath] = decrypted;
      return decrypted;
    } catch (e) {
      print("Decryption error for $assetPath: $e");
      throw Exception("Failed to decrypt asset");
    }
  }
}
