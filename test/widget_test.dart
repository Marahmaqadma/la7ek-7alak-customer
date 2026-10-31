import 'package:la7ek_7alak/features/auth/data/repositories/auth_repository_impl.dart';
import 'auth_remote_data_source_test.mocks.dart';
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:la7ek_7alak/main.dart';

void main() {
  testWidgets('App builds auth entry screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(La7ek7alakApp(
        appRouter: AppRouter(
            authRepository: AuthRepositoryImpl(MockAuthRemoteDataSource()))));

    // التطبيق يبدأ بالسبلاش؛ الفيديو لا يعمل في الاختبار فتنتقل فورًا
    // لشاشة الترحيب. ننتظر انتهاء الانتقال.
    await tester.pumpAndSettle();

    expect(find.text('أهلاً بك في لحق حالك'), findsOneWidget);
  });
}
