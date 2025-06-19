import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

// === DECRYPTION FUNCTION (for isolate use) ===
Uint8List _decrypt(Map<String, dynamic> params) {
  final Uint8List bytes = params['bytes'];
  final Uint8List key = params['key'];

  final nonce = bytes.sublist(0, 12);
  final ciphertext = bytes.sublist(12);

  final cipher = GCMBlockCipher(AESEngine())
    ..init(false, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));

  return cipher.process(ciphertext);
}

// === MEMORY CACHE FOR DECRYPTED IMAGES ===
final Map<String, Uint8List> decryptedImageCache = {};

// === STREAM-BASED IMAGE LOADER CLASS ===
class StreamedEncryptedImageLoader {
  final String assetPath;
  final String base64Key;

  StreamedEncryptedImageLoader(this.assetPath, this.base64Key);

  Stream<Uint8List> decryptStream() async* {
    if (decryptedImageCache.containsKey(assetPath)) {
      yield decryptedImageCache[assetPath]!;
      return;
    }

    try {
      final assetBytes = await rootBundle.load(assetPath);
      final bytes = assetBytes.buffer.asUint8List();
      final key = base64Decode(base64Key);

      final decrypted = await compute(_decrypt, {'bytes': bytes, 'key': key});
      decryptedImageCache[assetPath] = decrypted;
      yield decrypted;
    } catch (e) {
      yield* Stream.error(e);
    }
  }
}

// === STREAM IMAGE WIDGET ===
class EnyrptedImageWidget extends StatelessWidget {
  final String assetPath;
  final String base64Key;
  final double? height;
  final double? width;
  final BoxFit fit;

  const EnyrptedImageWidget({
    super.key,
    required this.assetPath,
    required this.base64Key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final loader = StreamedEncryptedImageLoader(assetPath, base64Key);

    return StreamBuilder<Uint8List>(
      stream: loader.decryptStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Icon(Icons.error, color: Colors.red);
        } else {
          return Image.memory(
            snapshot.data!,
            height: height,
            width: width,
            fit: fit,
            gaplessPlayback: true,
            filterQuality: FilterQuality.none,
          );
        }
      },
    );
  }
}
