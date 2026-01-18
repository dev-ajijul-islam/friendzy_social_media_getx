import 'package:friendzy_social_media_getx/bindings/welcome_binding.dart';
import 'package:friendzy_social_media_getx/modules/splash/views/splash_screen.dart';
import 'package:friendzy_social_media_getx/modules/welcome/views/welcome_screen.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.welcomeScreen,
      page: () => WelcomeScreen(),
      binding: WelcomeBinding(),
    ),
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
  ];
}
