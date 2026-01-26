import 'package:friendzy_social_media_getx/controllers/image_upload_controller.dart';
import 'package:friendzy_social_media_getx/controllers/like_post_controller.dart';
import 'package:friendzy_social_media_getx/modules/chats/controllers/chat_controller.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/followers_controllers.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/following_controllers.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/friends_controllers.dart';
import 'package:friendzy_social_media_getx/modules/home/controllers/get_all_post_controller.dart';
import 'package:friendzy_social_media_getx/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/get_my_posts_controller.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/get_my_stories_controllers.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:friendzy_social_media_getx/modules/post_details/controllers/full_image_view_controller.dart';
import 'package:friendzy_social_media_getx/modules/post_details/controllers/like_to_a_comment_controller.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/controllers/post_upload_controller.dart';
import 'package:get/get.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put( StoryController());
    Get.lazyPut(() => MainLayoutController());
    Get.put(MyProfileController());
    Get.lazyPut(() => PostUploadController());
    Get.put(ImageUploadController());
    Get.lazyPut(() => GetAllPostController());
    Get.put( GetMyPostsController());
    Get.put( GetMyStoriesControllers());
    Get.put( FullImageViewController());
    Get.put( LikePostController());
    Get.put( FriendsControllers());
    Get.put( FollowersControllers());
    Get.put( FollowingControllers());
    Get.put( ChatsController());
    Get.put( LikeToACommentController());
  }
}
