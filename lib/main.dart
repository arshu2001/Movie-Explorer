import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/views/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Movie Explorer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const SplashScreen(),
        );
      }
    );
  }
}
