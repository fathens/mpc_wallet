import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PartialKey {
  final String _bytes; // Base64
  const PartialKey(this._bytes);

  String get value => _bytes;

  Future<void> save() async {
    await _secureStorage.write(key: _storageName, value: _bytes);
  }

  static PartialKey empty() => const PartialKey("");

  static const _storageName = "partial_key";
  static const _secureStorage = FlutterSecureStorage();

  static Future<PartialKey?> load() async {
    final dataStr = await _secureStorage.read(key: _storageName);
    if (dataStr == null) {
      return null;
    }
    return PartialKey(dataStr);
  }
}
