import 'package:flutter/material.dart'; // Changed to material for ColorScheme
import 'package:friendzy_social_media_getx/routes/app_pages.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.routes,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF00334E),
          secondary: Color(0xFF006680),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF1A1A1A),

        ),
        scaffoldBackgroundColor: Colors.white,
      ),


      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00AFCC),
          secondary: Color(0xFF006680),
          surface: Color(0xFF121212),
          onPrimary: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),


      themeMode: ThemeMode.light,
    );
  }
}