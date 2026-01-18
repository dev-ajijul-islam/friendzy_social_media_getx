import 'package:friendzy_social_media_getx/modules/auth/controllers/sign_in_controller.dart';
import 'package:friendzy_social_media_getx/modules/auth/controllers/sign_up_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignUpController(),);
  }
}
