import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

import 'package:education/constant/ad_keys.dart';

class PDFViewerFromEncryptedAsset extends StatefulWidget {
  final String assetPath; // e.g., assets/encrypted/my_pdf.pdf.enc
  final String base64Key;

  const PDFViewerFromEncryptedAsset({
    super.key,
    required this.assetPath,
    required this.base64Key,
  });

  @override
  _PDFViewerFromEncryptedAssetState createState() =>
      _PDFViewerFromEncryptedAssetState();
}

class _PDFViewerFromEncryptedAssetState
    extends State<PDFViewerFromEncryptedAsset> {
  String? localPath;
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    loadEncryptedPDF();

    _bannerAd = BannerAd(
      adUnitId: bannerKey,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad load failed: ${error.message}');
        },
      ),
    )..load();
  }

  Future<void> loadEncryptedPDF() async {
    try {
      final encryptedData = await DefaultAssetBundle.of(
        context,
      ).load(widget.assetPath);
      final encryptedBytes = encryptedData.buffer.asUint8List();

      final key = base64Decode(widget.base64Key);
      final nonce = encryptedBytes.sublist(0, 12);
      final ciphertext = encryptedBytes.sublist(12);

      final cipher = GCMBlockCipher(AESEngine())..init(
        false,
        AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
      );

      final decryptedBytes = cipher.process(ciphertext);

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/decrypted_pdf.pdf');
      await file.writeAsBytes(decryptedBytes, flush: true);

      setState(() => localPath = file.path);
    } catch (e) {
      print("Decryption Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Encrypted PDF Viewer")),
      body: Column(
        children: [
          Expanded(
            child:
                localPath != null
                    ? PDFView(
                      filePath: localPath!,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: true,
                      enableSwipe: true,
                    )
                    : const Center(child: CircularProgressIndicator()),
          ),
          if (_isAdLoaded)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}
