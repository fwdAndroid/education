import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final secureRandom = Random.secure();
  final keyBytes = Uint8List(32);
  for (int i = 0; i < 32; i++) {
    keyBytes[i] = secureRandom.nextInt(256);
  }

  final base64Key = base64Encode(keyBytes);
  print('Base64 AES-256 Key:\n$base64Key');
}
