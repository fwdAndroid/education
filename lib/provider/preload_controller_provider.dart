import 'package:education/encryptions/imageloader_encryption.dart';
import 'package:flutter/foundation.dart';

class PreloadController extends ChangeNotifier {
  bool _imagesLoaded = false;
  bool get imagesLoaded => _imagesLoaded;

  double _progress = 0.0;
  double get progress => _progress;

  int _remainingSeconds = 0;
  int get remainingSeconds => _remainingSeconds;

  Future<void> preloadImages({
    required List<String> assetPaths,
    required String base64Key,
  }) async {
    if (_imagesLoaded) return;

    final preloader = ImagePreloader(
      assetPaths: assetPaths,
      base64Key: base64Key,
      concurrency: 4,
    );

    final stopwatch = Stopwatch()..start();

    await preloader.preloadAllImages(
      onProgress: (loaded, total) {
        if (total == 0) return;

        final elapsedMs = stopwatch.elapsed.inMilliseconds;
        final avgPerImage = elapsedMs / (loaded + 1);
        final estimatedRemainingMs = (total - loaded) * avgPerImage;

        _progress = loaded / total;
        _remainingSeconds = (estimatedRemainingMs / 1000).round();
        notifyListeners();
      },
    );

    _imagesLoaded = true;
    _progress = 1.0;
    _remainingSeconds = 0;
    notifyListeners();
  }
}
