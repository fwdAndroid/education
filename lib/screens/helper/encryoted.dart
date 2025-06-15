import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
  ImageStreamCompleter loadImage(
    EncryptedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(_loadAsync(key, decode));
  }

  Future<ImageInfo> _loadAsync(
    EncryptedImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    final encryptedBytes = await rootBundle.load(key.assetPath);
    final decryptedBytes = _decrypt(encryptedBytes.buffer.asUint8List());

    final codec = await decode(decryptedBytes as ImmutableBuffer);
    final frame = await codec.getNextFrame();
    return ImageInfo(image: frame.image);
  }

  Uint8List _decrypt(Uint8List encryptedBytes) {
    final key = encrypt.Key.fromBase64(base64Key);
    final iv = encrypt.IV.fromLength(16); // Assuming a static IV
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    final encrypted = encrypt.Encrypted(encryptedBytes);
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
    return Uint8List.fromList(decrypted);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncryptedImageProvider &&
          runtimeType == other.runtimeType &&
          assetPath == other.assetPath &&
          base64Key == other.base64Key;

  @override
  int get hashCode => assetPath.hashCode ^ base64Key.hashCode;
}
