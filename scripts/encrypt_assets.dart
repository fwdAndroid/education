// encrypt_images.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

void main() {
  final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  final inputDir = Directory('assets/raw');
  final outputDir = Directory('assets/encrypted');
  outputDir.createSync(recursive: true);

  for (var file in inputDir.listSync()) {
    if (file is File) {
      final bytes = file.readAsBytesSync();
      final encrypted = encrypter.encryptBytes(bytes, iv: iv);
      final outFile = File(
        '${outputDir.path}/${file.uri.pathSegments.last}.enc',
      );
      outFile.writeAsBytesSync(encrypted.bytes);
    }
  }

  Uint8List decrypt(Uint8List encryptedBytes) {
    // Example: XOR with 0xAA (same logic used in encryption)
    return Uint8List.fromList(encryptedBytes.map((b) => b ^ 0xAA).toList());
  }

  print(
    '✅ Encryption complete. Encrypted files saved in assets/images_encrypted/',
  );
}
