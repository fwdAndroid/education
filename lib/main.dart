import 'dart:convert';
import 'dart:typed_data';

import 'package:education/constant/ad_keys.dart';
import 'package:education/firebase_options.dart';
import 'package:education/image_provider.dart';
import 'package:education/imageloader.dart';
import 'package:education/newprovider.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();

  // Load saved bookmarks
  await BookmarkService().loadBookmarks();

  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Mobile Ads
  MobileAds.instance.initialize();

  // Hive initialization
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Open Hive boxes once
  if (!Hive.isBoxOpen('imageCache')) {
    await Hive.openBox<Uint8List>('imageCache');
  }
  if (!Hive.isBoxOpen('pdfCache')) {
    await Hive.openBox<Uint8List>('pdfCache');
  }

  // Launch app with Providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImagePreloadProvider()),
        ChangeNotifierProvider(create: (_) => PreloadController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
