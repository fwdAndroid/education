import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:pointycastle/export.dart';

Future<File> loadAndDecryptPdfFromAssets(
  String assetPath,
  String cacheKey,
  Uint8List aesKey,
) async {
  final cacheBox = await Hive.openBox('pdfCache');
  if (cacheBox.containsKey(cacheKey)) {
    final path = cacheBox.get(cacheKey);
    print('📂 Loaded from cache: $path');
    return File(path);
  }

  print('🔐 Loading asset: $assetPath');
  final encryptedBytes = await rootBundle.load(assetPath);
  final encryptedData = encryptedBytes.buffer.asUint8List();
  print('📦 Encrypted data size: ${encryptedData.length} bytes');

  final decryptedBytes = await decryptAESGCM(encryptedData, aesKey);

  final dir = await getTemporaryDirectory();
  final tempFile = File('${dir.path}/$cacheKey.pdf');
  await tempFile.writeAsBytes(decryptedBytes);
  await cacheBox.put(cacheKey, tempFile.path);

  print('✅ PDF decrypted and saved: ${tempFile.path}');
  return tempFile;
}

Future<Uint8List> decryptAESGCM(Uint8List combined, Uint8List key) async {
  try {
    if (combined.length < 12 + 16) {
      throw FormatException('Encrypted data too short.');
    }

    final nonce = combined.sublist(0, 12);
    final cipherTextWithTag = combined.sublist(12);

    print(
      '🧩 Nonce length: ${nonce.length}, Cipher+Tag: ${cipherTextWithTag.length}',
    );

    final cipher = GCMBlockCipher(
      AESEngine(),
    )..init(false, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));

    return cipher.process(cipherTextWithTag);
  } on InvalidCipherTextException catch (e) {
    print('❌ InvalidCipherTextException: ${e.message}');
    rethrow;
  } catch (e) {
    print('❌ Decryption failed: $e');
    rethrow;
  }
}
