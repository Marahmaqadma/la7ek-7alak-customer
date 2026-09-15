import 'package:la7ek_7alak/features/auth/data/repositories/auth_repository_impl.dart';
import 'auth_remote_data_source_test.mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la7ek_7alak/features/auth/data/models/register/register_request_body.dart';
import 'package:la7ek_7alak/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/register_page.dart';

class RecordingRegisterCubit extends RegisterCubit {
  RecordingRegisterCubit()
      : super(AuthRepositoryImpl(MockAuthRemoteDataSource()));
  RegisterRequestBody? submitted;
  @override
  void register(RegisterRequestBody body) {
    submitted = body;
    emit(RegisterLoading());
  }
}

void main() {
  testWidgets('Register UI validates confirmation and submits through cubit',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final cubit = RecordingRegisterCubit();
    addTearDown(cubit.close);
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 780),
      builder: (_, __) => MaterialApp(
          home: BlocProvider<RegisterCubit>.value(
        value: cubit,
        child: const RegisterPage(),
      )),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final fields = find.byType(TextFormField);
    for (final entry in [
      'Test User',
      'test@example.com',
      '0591234567',
      'Password1!',
      'Different1!'
    ].asMap().entries) {
      await tester.ensureVisible(fields.at(entry.key));
      await tester.enterText(fields.at(entry.key), entry.value);
    }
    await tester.ensureVisible(find.text('اختر مدينتك'));
    await tester.tap(find.text('اختر مدينتك'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('مدينة غزة'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(cubit.submitted, isNull);
    expect(find.text('يجب تطابق كلمتي المرور'), findsOneWidget);
    await tester.ensureVisible(fields.at(4));
    await tester.enterText(fields.at(4), 'Password1!');
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(cubit.submitted?.email, 'test@example.com');
    expect(cubit.submitted?.role, 'consumer');
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
