import 'dart:io';
import 'dart:typed_data';

import 'package:education/constant/ad_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFViewerFromAsset extends StatefulWidget {
  @override
  _PDFViewerFromAssetState createState() => _PDFViewerFromAssetState();
}

class _PDFViewerFromAssetState extends State<PDFViewerFromAsset> {
  String? localPath;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    loadEncryptedPDF();

    _bannerAd = BannerAd(
      adUnitId: bannerKey, // replace with your ad unit
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad load failed: ${error.message}');
        },
      ),
    )..load();
  }

  Future<void> loadEncryptedPDF() async {
    // Load asset PDF
    final byteData = await DefaultAssetBundle.of(
      context,
    ).load('assets/test.pdf');
    final Uint8List inputBytes = byteData.buffer.asUint8List();

    // Load PDF using Syncfusion and apply encryption
    final PdfDocument document = PdfDocument(inputBytes: inputBytes);
    document.security.userPassword = '';
    document.security.ownerPassword = 'owner123';
    final List<int> protectedBytes = await document.save();
    document.dispose();

    // Save it to internal storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/protected_test.pdf');
    await file.writeAsBytes(protectedBytes, flush: true);

    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chapter 9")),
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
                    : Center(child: CircularProgressIndicator()),
          ),
          if (_isAdLoaded)
            Container(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}
