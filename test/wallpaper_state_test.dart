import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:choice_helper/state/wallpaper_state.dart';

void main() {
  setUp(() {
    WallpaperState.currentWallpaperPath.value = null;
    SharedPreferences.setMockInitialValues({});
  });

  test('loadWallpaper restores an existing saved local path', () async {
    final file = File(
      '${Directory.systemTemp.path}/choice_helper_wallpaper_test.txt',
    );
    await file.writeAsString('wallpaper');
    SharedPreferences.setMockInitialValues({'wallpaperPath': file.path});

    await WallpaperState.loadWallpaper();

    expect(WallpaperState.currentWallpaperPath.value, file.path);

    await file.delete();
  });

  test(
    'loadWallpaper clears saved path when the file no longer exists',
    () async {
      final missingPath =
          '${Directory.systemTemp.path}/choice_helper_missing_wallpaper.jpg';
      SharedPreferences.setMockInitialValues({'wallpaperPath': missingPath});

      await WallpaperState.loadWallpaper();
      final prefs = await SharedPreferences.getInstance();

      expect(WallpaperState.currentWallpaperPath.value, isNull);
      expect(prefs.getString('wallpaperPath'), isNull);
    },
  );
}
