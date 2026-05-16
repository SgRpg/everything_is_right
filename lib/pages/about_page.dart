import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../widgets/app_background.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static final Uri _githubUri = Uri.parse(
    'https://github.com/SgRpg/everything_is_right',
  );

  late final Future<String> _versionFuture = _loadVersion();

  Future<String> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return 'v${packageInfo.version}';
    } catch (_) {
      return 'v1.0.0';
    }
  }

  Future<void> _openGithub() async {
    final opened = await launchUrl(
      _githubUri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || opened) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('暂时打不开链接，可以稍后再试～'),
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
                        '关于别纠结啦',
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
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.84),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                        boxShadow: softShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '别纠结啦',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.brown,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 14),
                          FutureBuilder<String>(
                            future: _versionFuture,
                            builder: (context, snapshot) {
                              return AboutInfoRow(
                                label: 'App 版本',
                                value: snapshot.data ?? 'v1.0.0',
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              '开发者：Sgr_Pig (HZ)',
                              style: TextStyle(
                                color: AppColors.brown,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const WarmDivider(),
                          Text(
                            '致使用者',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.brown,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '这个用来解决选择焦虑的 app 其实早就想做了的，平时我总是让朋友们替我决定去哪儿玩，晚饭吃什么，当然他们也总是问我，可惜我总是太忙，所有现在才把这个 “别纠结啦” app开发出来。感谢 ZZW 和 RAH 给我了灵感，最早是 ZZW 经常在寝室问我晚饭吃什么，而我总是回答不知道，那个时候就有了开发这个 app  的想法；我也总是问 RAH 晚饭吃什么，她总会给我一个决定，我觉得这让我很开心。\n\n\n'
                            '这个 app 的开发过程非常愉快，虽然中间也遇到了一些挑战，但想到我的朋友和亲人们能用上我开发的专属 APP 我就觉得特别开心。\n\n\n'
                            '这个 app 的名字 “别纠结啦” 其实也是我经常对自己说的话，希望它能成为你们在面对选择时的一个小小的鼓励，让你们能够更轻松地做出决定，享受生活中的每一个瞬间！\n\n\n'
                            '祝大家生活中都有一个可以让你相信 Ta 替你做出的决定并且让你开心的人~\n\n\n'
                            '这个 app 首先作为礼物送给 RAH 和 ZZW 以及我的家人们，谢谢你们'
                            ,
                            
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.softBrown,
                                  height: 1.6,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const WarmDivider(),
                          Text(
                            '项目 GitHub 仓库',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.brown,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Material(
                            color: const Color(0xFFFFF3E4),
                            borderRadius: BorderRadius.circular(18),
                            child: InkWell(
                              onTap: _openGithub,
                              borderRadius: BorderRadius.circular(18),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.open_in_new_rounded,
                                      color: AppColors.orange,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'https://github.com/SgRpg/everything_is_right',
                                        style: TextStyle(
                                          color: AppColors.brown,
                                          fontWeight: FontWeight.w800,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            '愿每一次小小的决定，都能把生活往前推一点点。',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.softBrown,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
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

class AboutInfoRow extends StatelessWidget {
  const AboutInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            '$label：',
            style: const TextStyle(
              color: AppColors.softBrown,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.brown,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WarmDivider extends StatelessWidget {
  const WarmDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 22),
      child: Divider(color: Color(0xFFF0D0BA)),
    );
  }
}
