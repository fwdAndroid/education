import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

Uint8List aesGcmEncrypt(Uint8List key, Uint8List nonce, Uint8List plaintext) {
  final cipher = GCMBlockCipher(AESEngine())
    ..init(true, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));

  return cipher.process(plaintext);
}

Future<void> main() async {
  const inputDirPath = 'assets/raw';
  const outputDirPath = 'assets/encrypted';
  const base64Key = '5geqnAHFbvM/CSiQqaG6rJd+ziSb/Hx5pUPc7YDxK4U=';
  final key = base64Decode(base64Key);

  final inputDir = Directory(inputDirPath);
  final outputDir = Directory(outputDirPath);

  if (!await inputDir.exists()) {
    print('❌ Input directory does not exist: ${inputDir.path}');
    exit(1);
  }

  await outputDir.create(recursive: true);

  // File extensions to encrypt
  final supportedExtensions = ['.png', '.jpg', '.jpeg', '.pdf'];

  // Setup secure random for nonce
  final random = SecureRandom('Fortuna')
    ..seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => 42))));

  final files = inputDir.listSync().whereType<File>().where(
    (f) => supportedExtensions.any((ext) => f.path.toLowerCase().endsWith(ext)),
  );

  for (final file in files) {
    final plaintext = await file.readAsBytes();
    final nonce = random.nextBytes(12);
    final encrypted = aesGcmEncrypt(key, nonce, plaintext);

    final combined =
        Uint8List(nonce.length + encrypted.length)
          ..setRange(0, nonce.length, nonce)
          ..setRange(nonce.length, nonce.length + encrypted.length, encrypted);

    final filename = '${file.uri.pathSegments.last}.enc';
    final outFile = File('${outputDir.path}/$filename');
    await outFile.writeAsBytes(combined);

    print('🔐 Encrypted: ${file.path} → ${outFile.path}');
  }

  print('✅ All supported files encrypted to: $outputDirPath');
}
