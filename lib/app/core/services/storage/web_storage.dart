import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_interface.dart';

class WebStorage implements StorageInterface {
  static const String _keyPrefix = 'linkedin_writer_';
  final _storage = const FlutterSecureStorage();

  String _getKey(String key) => '$_keyPrefix$key';

  @override
  Future<void> setValue(String key, String value) async {
    await _storage.write(key: _getKey(key), value: value);
  }

  @override
  Future<String?> getValue(String key) async {
    try {
      return await _storage.read(key: _getKey(key));
    } catch (e) {
      return null;
    }
  }
}
