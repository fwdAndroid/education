import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EncryptedImageCache {
  static final _cache = <String, Uint8List>{};

  static Uint8List? get(String key) => _cache[key];

  static void set(String key, Uint8List data) {
    if (_cache.length > 50) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = data;
  }

  static void clear() => _cache.clear();
}

Future<Uint8List> decryptImageData(Uint8List data, String base64Key) async {
  final key = encrypt.Key.fromBase64(base64Key);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final decrypted = encrypter.decryptBytes(encrypt.Encrypted(data), iv: iv);
  return Uint8List.fromList(decrypted);
}

Future<Uint8List> decryptImageInIsolate(Map<String, dynamic> args) async {
  final String path = args['path'];
  final String key = args['key'];
  final data = await rootBundle.load(path);
  return await decryptImageData(data.buffer.asUint8List(), key);
}

Future<Uint8List> decryptImage(String path, String base64Key) async {
  final cached = EncryptedImageCache.get(path);
  if (cached != null) return cached;
  final decrypted = await compute(decryptImageInIsolate, {
    'path': path,
    'key': base64Key,
  });
  EncryptedImageCache.set(path, decrypted);
  return decrypted;
}
