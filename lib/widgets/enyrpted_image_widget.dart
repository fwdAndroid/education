import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // for compute()
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

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
  Future<Uint8List>? _decryptionFuture;

  @override
  void initState() {
    super.initState();
    _decryptionFuture = _decryptImage();
  }

  Future<Uint8List> _decryptImage() async {
    final assetBytes = await rootBundle.load(widget.assetPath);
    final bytes = assetBytes.buffer.asUint8List();
    final key = base64Decode(widget.base64Key);

    // Pass raw bytes + key to compute isolate
    return compute(_decrypt, _DecryptParams(bytes, key));
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
            filterQuality: FilterQuality.medium,
          );
        }
      },
    );
  }
}

class _DecryptParams {
  final Uint8List encryptedBytes;
  final Uint8List key;

  _DecryptParams(this.encryptedBytes, this.key);
}

// This runs in the isolate (synchronously)
Uint8List _decrypt(_DecryptParams params) {
  final nonce = params.encryptedBytes.sublist(0, 12);
  final ciphertext = params.encryptedBytes.sublist(12);

  final cipher = GCMBlockCipher(AESEngine())..init(
    false,
    AEADParameters(KeyParameter(params.key), 128, nonce, Uint8List(0)),
  );

  return cipher.process(ciphertext);
}
