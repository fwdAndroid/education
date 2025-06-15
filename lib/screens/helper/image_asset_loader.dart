import 'package:encrypt/encrypt.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class EncryptedAssetLoader {
  static final _key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(
    AES(_key, mode: AESMode.cbc),
  ); // explicitly CBC

  static Future<Uint8List> loadDecrypted(String assetPath) async {
    final encryptedData = await rootBundle.load(assetPath);
    final encrypted = Encrypted(encryptedData.buffer.asUint8List());
    final decrypted = _encrypter.decryptBytes(encrypted, iv: _iv);
    return Uint8List.fromList(decrypted);
  }
}
