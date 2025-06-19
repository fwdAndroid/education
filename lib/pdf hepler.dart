import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';
import 'package:hive/hive.dart';

Future<Uint8List?> decryptAndCachePDF(
  String assetPath,
  String base64Key,
) async {
  final hiveBox = Hive.box<Uint8List>('pdfCache');

  if (hiveBox.containsKey(assetPath)) {
    return hiveBox.get(assetPath);
  }

  try {
    final data = await rootBundle.load(assetPath);
    final encrypted = data.buffer.asUint8List();
    final key = base64Decode(base64Key);

    final nonce = encrypted.sublist(0, 12);
    final ciphertext = encrypted.sublist(12);

    final cipher = GCMBlockCipher(
      AESEngine(),
    )..init(false, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));

    final decrypted = cipher.process(ciphertext);
    await hiveBox.put(assetPath, decrypted);
    return decrypted;
  } catch (e) {
    print("PDF decryption failed: $e");
    return null;
  }
}
