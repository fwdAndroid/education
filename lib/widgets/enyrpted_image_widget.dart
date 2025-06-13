// lib/widgets/encrypted_image.dart
import 'package:education/screens/helper/image_asset_loader.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class EncryptedImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width, height;

  const EncryptedImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: EncryptedAssetLoader.loadDecrypted(assetPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.memory(
            snapshot.data!,
            fit: fit,
            width: width,
            height: height,
          );
        } else if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        } else {
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
