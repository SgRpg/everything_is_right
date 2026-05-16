import 'dart:io';

import 'package:flutter/material.dart';

import '../state/wallpaper_state.dart';
import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: WallpaperState.currentWallpaperPath,
      builder: (context, wallpaperPath, _) {
        final wallpaperFile = wallpaperPath == null
            ? null
            : File(wallpaperPath);
        final hasWallpaper =
            wallpaperFile != null && wallpaperFile.existsSync();

        return Stack(
          fit: StackFit.expand,
          children: [
            if (hasWallpaper)
              Image.file(wallpaperFile, fit: BoxFit.cover)
            else
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.cream, Color(0xFFFFE5C4)],
                  ),
                ),
              ),
            if (hasWallpaper)
              Container(color: AppColors.cream.withValues(alpha: 0.68)),
            child,
          ],
        );
      },
    );
  }
}
