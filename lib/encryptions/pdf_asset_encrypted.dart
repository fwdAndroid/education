import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';

Future<File> loadAndDecryptPdfFromAssets(
  String assetPath,
  String cacheKey,
  Uint8List aesKey,
) async {
  // ✅ Correct Hive box type
  Box<String> cacheBox;

  if (Hive.isBoxOpen('pdfCacheBox')) {
    cacheBox = Hive.box<String>('pdfCacheBox');
  } else {
    cacheBox = await Hive.openBox<String>('pdfCacheBox');
  }

  // ✅ Return from cache if exists
  if (cacheBox.containsKey(cacheKey)) {
    final path = cacheBox.get(cacheKey);
    if (path != null && File(path).existsSync()) {
      return File(path);
    }
  }

  // Decrypt and store PDF
  final encryptedBytes = await rootBundle.load(assetPath);
  final encryptedData = encryptedBytes.buffer.asUint8List();
  final decryptedBytes = await decryptAESGCM(encryptedData, aesKey);

  final dir = await getTemporaryDirectory();
  final tempFile = File('${dir.path}/$cacheKey.pdf');
  await tempFile.writeAsBytes(decryptedBytes);

  await cacheBox.put(cacheKey, tempFile.path);
  return tempFile;
}

Future<Uint8List> decryptAESGCM(Uint8List combined, Uint8List key) async {
  final nonce = combined.sublist(0, 12);
  final cipherTextWithTag = combined.sublist(12);

  final cipher = GCMBlockCipher(AESEngine())
    ..init(false, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));

  return cipher.process(cipherTextWithTag);
}
