import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

// === DECRYPTION FUNCTION (Top-level for isolate use) ===
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

// === IMAGE WIDGET THAT LOADS ENCRYPTED IMAGES ===
class EnyrptedImageWidget extends StatefulWidget {
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
  State<EnyrptedImageWidget> createState() => _EnyrptedImageWidgetState();
}

class _EnyrptedImageWidgetState extends State<EnyrptedImageWidget> {
  late Future<Uint8List> _decryptionFuture;

  @override
  void initState() {
    super.initState();
    _decryptionFuture = _getOrDecrypt();
  }

  Future<Uint8List> _getOrDecrypt() async {
    if (decryptedImageCache.containsKey(widget.assetPath)) {
      return decryptedImageCache[widget.assetPath]!;
    }

    final assetBytes = await rootBundle.load(widget.assetPath);
    final bytes = assetBytes.buffer.asUint8List();
    final key = base64Decode(widget.base64Key);

    final decrypted = await compute(_decrypt, {'bytes': bytes, 'key': key});

    decryptedImageCache[widget.assetPath] = decrypted;
    return decrypted;
  }

  Future<void> preloadEncryptedImages(
    List<String> imagePaths,
    String base64Key,
  ) async {
    final key = base64Decode(base64Key);

    final futures = imagePaths.map((path) async {
      if (decryptedImageCache.containsKey(path)) return;

      final assetBytes = await rootBundle.load(path);
      final bytes = assetBytes.buffer.asUint8List();

      final decrypted = await compute(_decrypt, {'bytes': bytes, 'key': key});

      decryptedImageCache[path] = decrypted;
    });

    await Future.wait(futures); // Run all decryptions in parallel
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _decryptionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Icon(Icons.error, color: Colors.red);
        } else {
          return Image.memory(
            snapshot.data!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit,
            gaplessPlayback: true,
            filterQuality: FilterQuality.none,
          );
        }
      },
    );
  }
}
