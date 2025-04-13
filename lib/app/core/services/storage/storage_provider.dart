import 'package:flutter/foundation.dart';
import 'storage_interface.dart';
import 'web_storage.dart';

class StorageProvider {
  static StorageInterface get instance {
    if (kIsWeb) {
      return WebStorage();
    } else {
      throw UnimplementedError('Only web platform is supported');
    }
  }
}
