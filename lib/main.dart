import 'package:flutter/material.dart';
//importing the  screenutil package
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routing/app_router.dart';

void main() {
  runApp(La7ek7alakApp(appRouter: AppRouter()));
}

class La7ek7alakApp extends StatelessWidget {
  final AppRouter appRouter;

  const La7ek7alakApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 780),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Tajawal'),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouter.register,
          onGenerateRoute: appRouter.onGenerateRoute,
        );
      },
    );
  }
}
