import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

Uint8List _decrypt(Map<String, dynamic> params) {
  final Uint8List bytes = params['bytes'];
  final Uint8List key = params['key'];
  final nonce = bytes.sublist(0, 12);
  final ciphertext = bytes.sublist(12);

  final cipher = GCMBlockCipher(AESEngine())
    ..init(false, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));

  return cipher.process(ciphertext);
}

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
