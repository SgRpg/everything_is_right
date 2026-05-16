import 'dart:math';

import 'package:flutter/material.dart';

import 'pages/about_page.dart';
import 'pages/wallpaper_page.dart';
import 'state/wallpaper_state.dart';
import 'theme/app_colors.dart';
import 'widgets/app_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WallpaperState.loadWallpaper();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '别纠结啦',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.orange,
          brightness: Brightness.light,
        ),
        fontFamily: 'sans',
        scaffoldBackgroundColor: AppColors.cream,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WarmPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<HomeMenuAction>(
                  tooltip: '更多',
                  icon: const Icon(Icons.more_horiz_rounded),
                  color: AppColors.warmCream,
                  iconColor: AppColors.brown,
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: HomeMenuAction.wallpaper,
                      child: Text('换个心情'),
                    ),
                    PopupMenuItem(
                      value: HomeMenuAction.about,
                      child: Text('关于别纠结啦'),
                    ),
                  ],
                  onSelected: (action) {
                    final page = switch (action) {
                      HomeMenuAction.wallpaper => const WallpaperPage(),
                      HomeMenuAction.about => const AboutPage(),
                    };
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => page));
                  },
                ),
              ),
              const Spacer(),
              Text(
                '就这个吧',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '今天有什么让你纠结的小事吗？',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.softBrown,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const ChoiceIllustration(),
              const Spacer(flex: 2),
              PrimaryButton(
                label: '开始选择',
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const InputPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum HomeMenuAction { wallpaper, about }

class InputPage extends StatefulWidget {
  const InputPage({super.key, this.initialOptions});

  final List<String>? initialOptions;

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final List<TextEditingController> _controllers = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    final initialOptions = widget.initialOptions;
    if (initialOptions == null || initialOptions.isEmpty) {
      _controllers.addAll([TextEditingController(), TextEditingController()]);
    } else {
      _controllers.addAll(
        initialOptions.map((option) => TextEditingController(text: option)),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _controllers.removeAt(index).dispose();
    });
  }

  List<String> _validOptions() {
    return _controllers
        .map((controller) => controller.text.trim())
        .where((option) => option.isNotEmpty)
        .toList();
  }

  bool _ensureEnoughOptions(List<String> options) {
    if (options.length >= 2) {
      return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('至少给我两个选项嘛，不然我也没法帮你纠结～'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }

  void _chooseDirectly() {
    final options = _validOptions();
    if (!_ensureEnoughOptions(options)) {
      return;
    }

    final result = options[_random.nextInt(options.length)];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultPage(
          options: options,
          result: result,
          message: '其实没有正确的选择，只需要把你的选择变得正确',
        ),
      ),
    );
  }

  void _startElimination() {
    final options = _validOptions();
    if (!_ensureEnoughOptions(options)) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EliminationPage(options: options)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WarmPageScaffold(
      resizeToAvoidBottomInset: false,
      child: SafeArea(
        child: Column(
          children: [
            const WarmHeader(title: '输入选项', subtitle: '把纠结的选项都写下吧'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                children: [
                  for (var index = 0; index < _controllers.length; index++)
                    OptionInputCard(
                      controller: _controllers[index],
                      onDelete: () => _removeOption(index),
                    ),
                  AddOptionButton(onPressed: _addOption),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(label: '直接帮我选', onPressed: _chooseDirectly),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: '慢慢帮我排除',
                    icon: Icons.eco_rounded,
                    onPressed: _startElimination,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EliminationPage extends StatefulWidget {
  const EliminationPage({super.key, required this.options});

  final List<String> options;

  @override
  State<EliminationPage> createState() => _EliminationPageState();
}

class _EliminationPageState extends State<EliminationPage> {
  final Random _random = Random();
  late final List<String> _remainingOptions;

  static const List<String> _icons = ['🍲', '🍖', '🍣', '🍰', '🌿', '⭐'];

  @override
  void initState() {
    super.initState();
    _remainingOptions = [...widget.options];
  }

  void _finishWith(String result) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultPage(options: widget.options, result: result),
      ),
    );
  }

  void _removeOption(int index) {
    setState(() {
      _remainingOptions.removeAt(index);
    });

    if (_remainingOptions.length == 1) {
      _finishWith(_remainingOptions.first);
    }
  }

  void _chooseFromRemaining() {
    final result = _remainingOptions[_random.nextInt(_remainingOptions.length)];
    _finishWith(result);
  }

  @override
  Widget build(BuildContext context) {
    return WarmPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            const WarmHeader(title: '慢慢帮我排除', subtitle: '这几个里面，哪个可以先放一放？'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
                itemCount: _remainingOptions.length,
                itemBuilder: (context, index) {
                  return EliminationOptionCard(
                    icon: _icons[index % _icons.length],
                    label: _remainingOptions[index],
                    onTap: () => _removeOption(index),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  Text(
                    '💡 点选一个你可以先放一放的选项，我们会把它排除掉哦～',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.softBrown,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SecondaryButton(
                    label: '都很难放下，换个方式',
                    icon: Icons.refresh_rounded,
                    onPressed: _chooseFromRemaining,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.options,
    required this.result,
    this.message = '有时候决定不一定要完美，能让生活继续往前走就很好。',
  });

  final List<String> options;
  final String result;
  final String message;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final Random _random = Random();
  late String _result;

  @override
  void initState() {
    super.initState();
    _result = widget.result;
  }

  void _restartInput() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => InputPage(initialOptions: widget.options),
      ),
      (route) => route.isFirst,
    );
  }

  void _chooseAgain() {
    setState(() {
      _result = widget.options[_random.nextInt(widget.options.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WarmPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '结果',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              ResultCard(result: _result, message: widget.message),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: '重新选择',
                      icon: Icons.refresh_rounded,
                      onPressed: _restartInput,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: PrimaryButton(
                      label: '再来一次',
                      onPressed: _chooseAgain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarmPageScaffold extends StatelessWidget {
  const WarmPageScaffold({
    super.key,
    required this.child,
    this.resizeToAvoidBottomInset,
  });

  final Widget child;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: AppBackground(child: child),
    );
  }
}

class WarmHeader extends StatelessWidget {
  const WarmHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.brown,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.softBrown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class ChoiceIllustration extends StatelessWidget {
  const ChoiceIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(left: 22, top: 34, child: SoftDot(size: 18)),
          const Positioned(
            right: 34,
            top: 22,
            child: Text('✨', style: TextStyle(fontSize: 22)),
          ),
          const Positioned(
            left: 36,
            bottom: 42,
            child: Text('💗', style: TextStyle(fontSize: 20)),
          ),
          Transform.rotate(
            angle: -0.2,
            child: const MiniCard(color: Color(0xFFFFB281), label: '?'),
          ),
          Transform.translate(
            offset: const Offset(48, -8),
            child: Transform.rotate(
              angle: 0.08,
              child: const MiniCard(color: Color(0xFFFFDF8F), label: '★'),
            ),
          ),
          Transform.translate(
            offset: const Offset(88, 22),
            child: Transform.rotate(
              angle: 0.32,
              child: const MiniCard(color: Color(0xFFFFE8C8), label: '♥'),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 48),
            child: Container(
              width: 122,
              height: 112,
              decoration: BoxDecoration(
                color: AppColors.warmCream.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(28),
                boxShadow: softShadow,
              ),
              child: const Center(
                child: Text('• ᴗ •', style: TextStyle(fontSize: 28)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MiniCard extends StatelessWidget {
  const MiniCard({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: softShadow,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class OptionInputCard extends StatelessWidget {
  const OptionInputCard({
    super.key,
    required this.controller,
    required this.onDelete,
  });

  final TextEditingController controller;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(20, 4, 10, 4),
      decoration: BoxDecoration(
        color: AppColors.warmCream.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: AppColors.brown,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              decoration: const InputDecoration(
                hintText: '写一个选项',
                hintStyle: TextStyle(
                  color: Color(0xFFC69B83),
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close_rounded),
            color: const Color(0xFFDABEA8),
            tooltip: '删除选项',
          ),
        ],
      ),
    );
  }
}

class AddOptionButton extends StatelessWidget {
  const AddOptionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded),
      label: const Text('添加一个选项'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.softBrown,
        side: const BorderSide(
          color: Color(0xFFF4C99F),
          style: BorderStyle.solid,
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class EliminationOptionCard extends StatelessWidget {
  const EliminationOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColors.warmCream.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(18),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
              boxShadow: softShadow,
            ),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Icon(Icons.check_circle_rounded, color: AppColors.orange),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.result, required this.message});

  final String result;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.035,
      child: Container(
        padding: const EdgeInsets.fromLTRB(28, 34, 28, 34),
        decoration: BoxDecoration(
          color: AppColors.warmCream.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 46)),
            const SizedBox(height: 16),
            Text(
              '就选它吧',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.brown,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              result,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 22),
            const Divider(color: Color(0xFFF0D0BA)),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.softBrown,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 17),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 6,
        shadowColor: AppColors.orange.withValues(alpha: 0.32),
      ),
      child: Text(label),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.favorite_rounded),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFFFD08B),
        foregroundColor: AppColors.brown,
        padding: const EdgeInsets.symmetric(vertical: 17),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class SoftDot extends StatelessWidget {
  const SoftDot({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.apricot.withValues(alpha: 0.42),
        shape: BoxShape.circle,
      ),
    );
  }
}
