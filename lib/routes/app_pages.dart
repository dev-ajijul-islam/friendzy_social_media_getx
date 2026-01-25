import 'package:friendzy_social_media_getx/bindings/auth_binding.dart';
import 'package:friendzy_social_media_getx/bindings/comment_binding.dart';
import 'package:friendzy_social_media_getx/bindings/main_layout_binding.dart';
import 'package:friendzy_social_media_getx/bindings/welcome_binding.dart';
import 'package:friendzy_social_media_getx/modules/auth/views/forgot_password_screen.dart';
import 'package:friendzy_social_media_getx/modules/auth/views/sign_in_screen.dart';
import 'package:friendzy_social_media_getx/modules/auth/views/sign_up_screen.dart';
import 'package:friendzy_social_media_getx/modules/main_layout/views/main_layout.dart';
import 'package:friendzy_social_media_getx/modules/splash/views/splash_screen.dart';
import 'package:friendzy_social_media_getx/modules/stories/views/add_story_screen.dart';
import 'package:friendzy_social_media_getx/modules/stories/views/story_details_screen.dart';
import 'package:friendzy_social_media_getx/modules/welcome/views/welcome_screen.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/views/edit_profile_screen.dart';
import 'package:friendzy_social_media_getx/modules/user_profile/views/user_profile_screen.dart';
import 'package:friendzy_social_media_getx/modules/notifications/views/notification_screen.dart';
import 'package:friendzy_social_media_getx/modules/post_details/views/post_details_screen.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.welcomeScreen,
      page: () => WelcomeScreen(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: AppRoutes.signInScreen,
      page: () => SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgetPasswordScreen,
      page: () => ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.mainLayout,
      page: () => MainLayout(),
      binding: MainLayoutBinding(),
    ),
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.editProfile, page: () => EditProfileScreen()),
    GetPage(name: AppRoutes.userProfile, page: () => UserProfileScreen()),
    GetPage(name: AppRoutes.addStoryScreen, page: () => AddStoryScreen()),
    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => NotificationScreen(),
    ),
    GetPage(
      name: AppRoutes.postDetailsScreen,
      page: () => PostDetailsScreen(),
      binding: CommentBinding(),
    ),
    GetPage(
      name: AppRoutes.storyDetailsScreen,
      page: () => StoryDetailsScreen(),
    ),
  ];
}
