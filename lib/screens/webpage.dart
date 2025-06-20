import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerFromCache extends StatefulWidget {
  final File pdfFile;

  const PDFViewerFromCache({super.key, required this.pdfFile});

  @override
  State<PDFViewerFromCache> createState() => _PDFViewerFromCacheState();
}

class _PDFViewerFromCacheState extends State<PDFViewerFromCache> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cached PDF Viewer")),
      body: PDFView(
        filePath: widget.pdfFile.path,
        autoSpacing: true,
        swipeHorizontal: false,
        pageSnap: true,
      ),
    );
  }
}
