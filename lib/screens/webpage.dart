import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerPage({super.key, required this.pdfUrl});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    // Use Google Docs Viewer for better PDF support
    final viewerUrl =
        "https://docs.google.com/gview?embedded=true&url=${Uri.encodeFull(widget.pdfUrl)}";

    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(viewerUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
