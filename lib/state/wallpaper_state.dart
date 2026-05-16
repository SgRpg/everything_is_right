import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WallpaperState {
  static const String _wallpaperPathKey = 'wallpaperPath';

  static final ValueNotifier<String?> currentWallpaperPath =
      ValueNotifier<String?>(null);

  static Future<void> loadWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_wallpaperPathKey);

    if (savedPath == null || savedPath.isEmpty) {
      currentWallpaperPath.value = null;
      return;
    }

    if (await File(savedPath).exists()) {
      currentWallpaperPath.value = savedPath;
      return;
    }

    await prefs.remove(_wallpaperPathKey);
    currentWallpaperPath.value = null;
  }

  static Future<bool> pickWallpaper() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return false;
    }

    final localPath = await copyImageToLocalDirectory(image);
    await saveWallpaperPath(localPath);
    return true;
  }

  static Future<void> clearWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wallpaperPathKey);
    currentWallpaperPath.value = null;
  }

  static Future<void> saveWallpaperPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_wallpaperPathKey, path);
    currentWallpaperPath.value = path;
  }

  static Future<String> copyImageToLocalDirectory(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final wallpaperDirectory = Directory('${directory.path}/wallpapers');
    if (!await wallpaperDirectory.exists()) {
      await wallpaperDirectory.create(recursive: true);
    }

    final extension = _extensionFromPath(image.path);
    final filename =
        'wallpaper_${DateTime.now().millisecondsSinceEpoch}$extension';
    final copiedFile = await File(
      image.path,
    ).copy('${wallpaperDirectory.path}/$filename');
    return copiedFile.path;
  }

  static String _extensionFromPath(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == path.length - 1) {
      return '.jpg';
    }

    return path.substring(dotIndex);
  }
}
