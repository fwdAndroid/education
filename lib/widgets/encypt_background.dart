import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart' show AESEngine;
import 'package:pointycastle/block/modes/gcm.dart';

class EncryptedBackgroundContainer extends StatefulWidget {
  final String assetPath;
  final String base64Key;
  final Widget child;

  const EncryptedBackgroundContainer({
    super.key,
    required this.assetPath,
    required this.base64Key,
    required this.child,
  });

  @override
  State<EncryptedBackgroundContainer> createState() =>
      _EncryptedBackgroundContainerState();
}

class _EncryptedBackgroundContainerState
    extends State<EncryptedBackgroundContainer> {
  Uint8List? decryptedBytes;

  @override
  void initState() {
    super.initState();
    _decryptBackground();
  }

  Future<void> _decryptBackground() async {
    final encryptedData = await rootBundle.load(widget.assetPath);
    final encryptedBytes = encryptedData.buffer.asUint8List();
    final key = base64Decode(widget.base64Key);

    final nonce = encryptedBytes.sublist(0, 12);
    final ciphertext = encryptedBytes.sublist(12);

    final cipher = GCMBlockCipher(
      AESEngine(),
    )..init(false, AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)));

    try {
      final decrypted = cipher.process(ciphertext);
      setState(() {
        decryptedBytes = decrypted;
      });
    } catch (e) {
      debugPrint('Decryption failed: $e');
      // optionally handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (decryptedBytes == null) {
      // Loading fallback
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(decryptedBytes!),
          fit: BoxFit.cover,
        ),
      ),
      child: widget.child,
    );
  }
}
