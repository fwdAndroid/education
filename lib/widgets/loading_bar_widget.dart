import 'package:flutter/material.dart';

class LoadingProgressDisplay extends StatelessWidget {
  final ValueNotifier<double> progressNotifier;
  final ValueNotifier<int> remainingSecondsNotifier;

  const LoadingProgressDisplay({
    super.key,
    required this.progressNotifier,
    required this.remainingSecondsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: progressNotifier,
      builder: (context, progress, _) {
        return ValueListenableBuilder<int>(
          valueListenable: remainingSecondsNotifier,
          builder: (context, remaining, _) {
            if (progress >= 1.0) return const SizedBox.shrink(); // hide if done
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 6),
                  Text(
                    "Loading content: ${(progress * 100).toStringAsFixed(0)}% • ${remaining}s remaining",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
