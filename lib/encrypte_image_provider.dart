import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive/hive.dart';

class EncryptedImageProvider extends ImageProvider<EncryptedImageProvider> {
  final String assetPath;
  final String base64Key;

  const EncryptedImageProvider({
    required this.assetPath,
    required this.base64Key,
  });

  @override
  Future<EncryptedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<EncryptedImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(EncryptedImageProvider key, var decode) {
    return OneFrameImageStreamCompleter(_loadAsync(key, decode));
  }

  Future<ImageInfo> _loadAsync(EncryptedImageProvider key, var decode) async {
    final box = Hive.box<Uint8List>('imageCache');
    final cacheKey = key.assetPath;

    // Return cached image if available
    if (box.containsKey(cacheKey)) {
      final cachedBytes = box.get(cacheKey)!;
      final codec = await decode(cachedBytes);
      final frame = await codec.getNextFrame();
      return ImageInfo(image: frame.image);
    }

    // Load encrypted asset
    final encryptedBytes = await rootBundle.load(key.assetPath);
    final decryptedBytes = _decrypt(encryptedBytes.buffer.asUint8List());

    // Cache for future
    await box.put(cacheKey, decryptedBytes);

    final codec = await decode(decryptedBytes);
    final frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image);
  }

  Uint8List _decrypt(Uint8List encrypted) {
    final key = encrypt.Key.fromBase64(base64Key);
    final iv = encrypt.IV(encrypted.sublist(0, 12)); // GCM IV is 12 bytes
    final cipherText = encrypted.sublist(12);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.gcm),
    );
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(cipherText),
      iv: iv,
    );
    return Uint8List.fromList(decrypted);
  }

  @override
  bool operator ==(Object other) {
    return other is EncryptedImageProvider &&
        assetPath == other.assetPath &&
        base64Key == other.base64Key;
  }

  @override
  int get hashCode => Object.hash(assetPath, base64Key);
}
