import 'package:la7ek_7alak/features/auth/data/repositories/auth_repository_impl.dart';
import 'auth_remote_data_source_test.mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:la7ek_7alak/features/auth/data/models/city/city_model.dart';
import 'package:la7ek_7alak/features/auth/data/models/register/register_request_body.dart';
import 'package:la7ek_7alak/features/auth/presentation/cubit/cities/cities_cubit.dart';
import 'package:la7ek_7alak/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/location_picker_page.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/register_page.dart';

class RecordingRegisterCubit extends RegisterCubit {
  RecordingRegisterCubit()
      : super(AuthRepositoryImpl(MockAuthRemoteDataSource()));
  RegisterRequestBody? submitted;
  @override
  Future<void> register(RegisterRequestBody body) async {
    submitted = body;
    emit(RegisterLoading());
  }
}

// مدن جاهزة بدل طلبها من الخادم.
class FakeCitiesCubit extends CitiesCubit {
  FakeCitiesCubit() : super(AuthRepositoryImpl(MockAuthRemoteDataSource())) {
    emit(const CitiesState(
      status: CitiesStatus.loaded,
      cities: [
        CityModel(
          id: 2,
          area: 'غزة',
          governorate: 'الشمال',
          latitude: 31.5016,
          longitude: 34.4668,
        ),
        CityModel(
          id: 3,
          area: 'النصيرات',
          governorate: 'الوسطى',
          latitude: 31.4504,
          longitude: 34.3936,
        ),
      ],
    ));
  }
}

// بديل شاشة الخريطة في الاختبار: يؤكد نقطة قريبة من مدينة غزة.
Route<dynamic> fakeMapRoute(RouteSettings settings) =>
    MaterialPageRoute<PickedLocation>(
      settings: settings,
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => Navigator.pop<PickedLocation>(
            context,
            (latitude: 31.50, longitude: 34.46),
          ),
          child: const Text('fake-confirm'),
        ),
      ),
    );

void main() {
  testWidgets('Register UI validates confirmation and submits through cubit',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final cubit = RecordingRegisterCubit();
    addTearDown(cubit.close);
    final citiesCubit = FakeCitiesCubit();
    addTearDown(citiesCubit.close);
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 780),
      builder: (_, __) => MaterialApp(
          onGenerateRoute: fakeMapRoute,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<RegisterCubit>.value(value: cubit),
              BlocProvider<CitiesCubit>.value(value: citiesCubit),
            ],
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
    await tester.ensureVisible(find.text('حدد موقعك على الخريطة'));
    await tester.tap(find.text('حدد موقعك على الخريطة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('fake-confirm'));
    await tester.pumpAndSettle();
    // النقطة أقرب لغزة من النصيرات، فتُختار غزة.
    expect(find.text('غزة'), findsOneWidget);
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
    expect(cubit.submitted?.address, 'غزة');
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
