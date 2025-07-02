import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ImagePreloader {
  final List<String> assetPaths;
  final String base64Key;
  final int concurrency;

  ImagePreloader({
    required this.assetPaths,
    required this.base64Key,
    this.concurrency = 4,
  });

  Future<void> preloadAllImages({
    required void Function(int loaded, int total) onProgress,
  }) async {
    final box = Hive.box<Uint8List>('imageCache');
    final key = base64Decode(base64Key);
    int loadedCount = 0;

    final queue = List<String>.from(assetPaths);

    Future<void> worker() async {
      while (true) {
        if (queue.isEmpty) break;
        final path = queue.removeAt(0);

        if (!box.containsKey(path)) {
          try {
            final encryptedBytes = await rootBundle.load(path);
            final decrypted = await compute(_decrypt, {
              'bytes': encryptedBytes.buffer.asUint8List(),
              'key': key,
            });
            await box.put(path, decrypted);
          } catch (e) {
            debugPrint('Error decrypting $path: $e');
          }
        }

        loadedCount++;
        onProgress(loadedCount, assetPaths.length);
      }
    }

    final workers = List.generate(concurrency, (_) => worker());
    await Future.wait(workers);
  }
}

// Top-level function required for compute()
Uint8List _decrypt(Map<String, dynamic> args) {
  final bytes = args['bytes'] as Uint8List;
  final key = args['key'] as Uint8List;

  final iv = bytes.sublist(0, 12);
  final tag = bytes.sublist(bytes.length - 16);
  final cipherText = bytes.sublist(12, bytes.length - 16);

  final aes = encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.gcm);

  final encrypter = encrypt.Encrypter(aes);

  final decrypted = encrypter.decryptBytes(
    encrypt.Encrypted(Uint8List.fromList(cipherText + tag)),
    iv: encrypt.IV(iv),
  );

  return Uint8List.fromList(decrypted);
}
