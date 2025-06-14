import 'package:flutter/material.dart';

class ContentLicensePage extends StatefulWidget {
  const ContentLicensePage({super.key});

  @override
  State<ContentLicensePage> createState() => _ContentLicensePageState();
}

class _ContentLicensePageState extends State<ContentLicensePage> {
  // Function to show image in a popup
  void _showImagePopup(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.1,
                maxScale: 5.0,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Image widget with tap functionality
  Widget _buildImage(String path) {
    return GestureDetector(
      onTap: () => _showImagePopup(path),
      child: Image.asset(path, height: 180, width: 180, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Content License",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffab77ff),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImage("assets/raw/chemxi_Page031.jpg"),
                _buildImage("assets/raw/chemxi_Page031.jpg"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImage("assets/raw/chemxi_Page031.jpg"),
                _buildImage("assets/raw/chemxi_Page031.jpg"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
