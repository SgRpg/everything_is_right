import 'dart:io';

import 'package:flutter/material.dart';

import '../state/wallpaper_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';

class WallpaperPage extends StatelessWidget {
  const WallpaperPage({super.key});

  Future<void> _pickWallpaper(BuildContext context) async {
    final changed = await WallpaperState.pickWallpaper();
    if (!context.mounted || !changed) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('壁纸已经换好啦～'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _clearWallpaper(BuildContext context) async {
    await WallpaperState.clearWallpaper();
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已经恢复默认背景啦～'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColors.brown,
                    ),
                    Expanded(
                      child: Text(
                        '换个心情',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.brown,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '从相册选一张喜欢的图片，给今天换个底色～',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.softBrown,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                const WallpaperPreview(),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _pickWallpaper(context),
                  icon: const Icon(Icons.image_rounded),
                  label: const Text('从相册选择'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => _clearWallpaper(context),
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('恢复默认背景'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD08B),
                    foregroundColor: AppColors.brown,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '图片只会保存在你的手机里，不会上传～',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.softBrown,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WallpaperPreview extends StatelessWidget {
  const WallpaperPreview({super.key});

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

        return Container(
          height: 260,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
            boxShadow: softShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: hasWallpaper
              ? Image.file(wallpaperFile, fit: BoxFit.cover)
              : DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.warmCream, Color(0xFFFFD7AE)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '当前使用默认背景',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.brown,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
