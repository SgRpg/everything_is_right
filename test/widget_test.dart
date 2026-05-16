import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:choice_helper/main.dart';
import 'package:choice_helper/state/wallpaper_state.dart';

void main() {
  setUp(() {
    WallpaperState.currentWallpaperPath.value = null;
    PackageInfo.setMockInitialValues(
      appName: 'choice_helper',
      packageName: 'com.example.choice_helper',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('shows home page and opens input page', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('就这个吧'), findsOneWidget);
    expect(find.text('今天有什么让你纠结的小事吗？'), findsOneWidget);
    expect(find.text('开始选择'), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);

    await tester.tap(find.text('开始选择'));
    await tester.pumpAndSettle();

    expect(find.text('输入选项'), findsOneWidget);
    expect(find.text('把纠结的选项都写下吧'), findsOneWidget);
  });

  testWidgets('shows a gentle prompt when fewer than two options are entered', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('开始选择'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('直接帮我选'));
    await tester.pump();

    expect(find.text('至少给我两个选项嘛，不然我也没法帮你纠结～'), findsOneWidget);
  });

  testWidgets('input page does not move bottom actions above the keyboard', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('开始选择'));
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);

    expect(scaffold.resizeToAvoidBottomInset, isFalse);
  });

  testWidgets('random choice opens result page with the original options', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('开始选择'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '火锅');
    await tester.enterText(find.byType(TextField).at(1), '烤肉');
    await tester.tap(find.text('直接帮我选'));
    await tester.pumpAndSettle();

    expect(find.text('结果'), findsOneWidget);
    expect(find.text('就选它吧'), findsOneWidget);
    expect(find.text('其实没有正确的选择，只需要把你的选择变得正确'), findsOneWidget);
    expect(find.text('重新选择'), findsOneWidget);
    expect(find.text('再来一次'), findsOneWidget);
    expect(
      find.text('火锅').evaluate().isNotEmpty ||
          find.text('烤肉').evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('elimination removes choices until one result remains', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('开始选择'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '火锅');
    await tester.enterText(find.byType(TextField).at(1), '烤肉');
    await tester.tap(find.text('添加一个选项'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(2), '日料');

    await tester.tap(find.text('慢慢帮我排除'));
    await tester.pumpAndSettle();

    expect(find.text('慢慢帮我排除'), findsOneWidget);
    await tester.tap(find.text('火锅'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('烤肉'));
    await tester.pumpAndSettle();

    expect(find.text('结果'), findsOneWidget);
    expect(find.text('日料'), findsOneWidget);
  });

  testWidgets('wallpaper entry opens wallpaper page', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('换个心情'));
    await tester.pumpAndSettle();

    expect(find.text('换个心情'), findsOneWidget);
    expect(find.text('从相册选一张喜欢的图片，给今天换个底色～'), findsOneWidget);
    expect(find.text('当前使用默认背景'), findsOneWidget);
    expect(find.text('从相册选择'), findsOneWidget);
    expect(find.text('恢复默认背景'), findsOneWidget);
    expect(find.text('图片只会保存在你的手机里，不会上传～'), findsOneWidget);
  });

  testWidgets('about entry opens about page', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('关于别纠结啦'));
    await tester.pumpAndSettle();

    expect(find.text('关于别纠结啦'), findsOneWidget);
    expect(find.text('别纠结啦'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);
    expect(find.text('开发者：Sgr_Pig (HZ)'), findsOneWidget);
    expect(find.text('致使用者'), findsOneWidget);
    expect(find.textContaining('解决选择焦虑'), findsOneWidget);
    expect(
      find.text('https://github.com/SgRpg/everything_is_right'),
      findsOneWidget,
    );
    expect(find.text('愿每一次小小的决定，都能把生活往前推一点点。'), findsOneWidget);
  });
}
