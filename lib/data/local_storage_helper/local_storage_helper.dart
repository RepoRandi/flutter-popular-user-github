import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageHelper {
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> saveImage(File imageFile, String fileName) async {
    final path = await localPath;
    final File localImage = File('$path/$fileName');
    await localImage.writeAsBytes(await imageFile.readAsBytes());
    return localImage;
  }

  static Future<File?> loadImage(String fileName) async {
    try {
      final path = await localPath;
      return File('$path/$fileName');
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }
}
