import 'dart:convert';
import 'dart:typed_data';

import 'package:education/firebase_options.dart';
import 'package:education/image_provider.dart';
import 'package:education/newprovider.dart';
import 'package:education/service/book_mark_service.dart';
import 'package:education/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<List<String>> getEncryptedImagePaths() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestJson);
  return manifestMap.keys
      .where(
        (key) => key.startsWith('assets/encrypted/') && key.endsWith('.enc'),
      )
      .toList();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  await BookmarkService().loadBookmarks();

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // ✅ Correct Hive box types
  if (!Hive.isBoxOpen('imageCache')) {
    await Hive.openBox<Uint8List>('imageCache'); // binary image cache
  }

  if (!Hive.isBoxOpen('pdfCacheBox')) {
    await Hive.openBox<String>('pdfCacheBox'); // ✅ store file paths as String
  }

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
