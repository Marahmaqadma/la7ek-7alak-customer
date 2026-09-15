import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:la7ek_7alak/features/intro/presentation/pages/intro_page.dart';

void main() {
  testWidgets('Intro fits phone sizes and opens login', (tester) async {
    final loader = FontLoader('Tajawal')
      ..addFont(rootBundle.load('assets/fonts/Tajawal-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Tajawal-Bold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Tajawal-Medium.ttf'));
    await loader.load();
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundary = GlobalKey();
    for (final size in [
      const Size(375, 812),
      const Size(360, 640),
      const Size(430, 932)
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(ScreenUtilInit(
        designSize: const Size(360, 780),
        builder: (_, __) => MaterialApp(
          theme: ThemeData(fontFamily: 'Tajawal'),
          routes: {
            AppRouter.login: (_) =>
                const Scaffold(body: Text('Login destination'))
          },
          home: RepaintBoundary(key: boundary, child: const IntroPage()),
        ),
      ));
      await tester.runAsync(() => precacheImage(
            const AssetImage('assets/images/intro_illustration.jpg'),
            tester.element(find.byType(IntroPage)),
          ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('أهلاً بك في لحق حالك'), findsOneWidget);
      if (size.width == 375) {
        await tester.runAsync(() async {
          final image = await (boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary)
              .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File('build/intro_preview.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    }
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();
    expect(find.text('Login destination'), findsOneWidget);
  });
}
