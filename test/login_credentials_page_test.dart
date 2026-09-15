import 'package:la7ek_7alak/features/auth/data/repositories/auth_repository_impl.dart';
import 'auth_remote_data_source_test.mocks.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la7ek_7alak/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/login_credentials_page.dart';
import 'package:la7ek_7alak/features/auth/presentation/widgets/login_type_card.dart';

void main() {
  testWidgets('Login layout and password controls fit phone sizes',
      (tester) async {
    final loader = FontLoader('Tajawal')
      ..addFont(rootBundle.load('assets/fonts/Tajawal-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Tajawal-Medium.ttf'));
    await loader.load();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final size in [
      const Size(375, 812),
      const Size(360, 640),
      const Size(430, 932)
    ]) {
      tester.view.physicalSize = size;
      final boundary = GlobalKey();
      await tester.pumpWidget(ScreenUtilInit(
        designSize: const Size(360, 780),
        builder: (_, __) => MaterialApp(
            theme: ThemeData(fontFamily: 'Tajawal'),
            home: BlocProvider(
                create: (_) =>
                    LoginCubit(AuthRepositoryImpl(MockAuthRemoteDataSource())),
                child: RepaintBoundary(
                    key: boundary,
                    child: const LoginCredentialsPage(
                        loginType: LoginType.consumer)))),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (size.width == 375) {
        await tester.runAsync(() async {
          final image = await (boundary.currentContext!.findRenderObject()
                  as RenderRepaintBoundary)
              .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File('build/login_preview.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField).last).obscureText,
          false);
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });
}
