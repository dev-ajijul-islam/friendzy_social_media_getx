import 'package:friendzy_social_media_getx/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/controllers/post_upload_controller.dart';
import 'package:get/get.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainLayoutController());
    Get.put(MyProfileController());
    Get.lazyPut(() => PostUploadController());
  }
}
