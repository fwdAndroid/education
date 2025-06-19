import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

import 'package:education/constant/ad_keys.dart';

class PDFViewerFromEncryptedAsset extends StatefulWidget {
  final String assetPath;
  final String base64Key;

  const PDFViewerFromEncryptedAsset({
    super.key,
    required this.assetPath,
    required this.base64Key,
  });

  @override
  State<PDFViewerFromEncryptedAsset> createState() =>
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
    _loadPDFWithHiveCache();

    _bannerAd = BannerAd(
      adUnitId: bannerKey,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Ad load failed: ${error.message}');
        },
      ),
    )..load();
  }

  Future<void> _loadPDFWithHiveCache() async {
    try {
      final box = Hive.box<Uint8List>('pdfCache');

      Uint8List? decryptedBytes;

      if (box.containsKey(widget.assetPath)) {
        decryptedBytes = box.get(widget.assetPath);
        debugPrint("Loaded PDF from Hive cache.");
      } else {
        final encryptedData = await DefaultAssetBundle.of(
          context,
        ).load(widget.assetPath);
        final bytes = encryptedData.buffer.asUint8List();
        final key = base64Decode(widget.base64Key);
        final nonce = bytes.sublist(0, 12);
        final ciphertext = bytes.sublist(12);

        final cipher = GCMBlockCipher(AESEngine())..init(
          false,
          AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
        );

        decryptedBytes = cipher.process(ciphertext);

        await box.put(widget.assetPath, decryptedBytes);
        debugPrint("Decrypted and cached PDF.");
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/decrypted_${widget.assetPath.split('/').last}.pdf',
      );
      await file.writeAsBytes(decryptedBytes!, flush: true);

      setState(() => localPath = file.path);
    } catch (e) {
      debugPrint("Error loading PDF: $e");
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
