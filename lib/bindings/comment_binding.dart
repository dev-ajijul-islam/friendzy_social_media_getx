import 'package:friendzy_social_media_getx/modules/post_details/controllers/create_comment_controller.dart';
import 'package:get/get.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateCommentController());
  }
}
