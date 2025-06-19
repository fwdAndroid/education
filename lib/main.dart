import 'dart:convert';
import 'dart:typed_data';

import 'package:education/constant/ad_keys.dart';
import 'package:education/firebase_options.dart';
import 'package:education/pdf%20hepler.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<List<String>> getEncryptedImagePaths() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestJson);
  final encryptedPaths =
      manifestMap.keys
          .where(
            (key) =>
                key.startsWith('assets/encrypted/') && key.endsWith('.enc'),
          )
          .toList();
  return encryptedPaths;
}

Future<List<String>> getEncryptedPdfPaths() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final manifestMap = json.decode(manifestJson);
  return manifestMap.keys
      .where(
        (key) =>
            key.startsWith('assets/encrypted/') && key.endsWith('.pdf.enc'),
      )
      .toList();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await BookmarkService().loadBookmarks();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  MobileAds.instance.initialize();

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  await Hive.openBox<Uint8List>('imageCache');
  await Hive.openBox<Uint8List>('pdfCache'); // <-- New line

  final encryptedImages = await getEncryptedImagePaths();
  final encryptedPDFs = await getEncryptedPdfPaths();

  // Optional preload during splash
  for (final pdf in encryptedPDFs.take(2)) {
    // Only preload 2
    await decryptAndCachePDF(pdf, base24); // Assuming base24 is your key
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(allEncryptedImagePaths: encryptedImages),
    ),
  );
}
