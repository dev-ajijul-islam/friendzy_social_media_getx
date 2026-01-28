import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/friends_controllers.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final FriendsControllers friendsControllers = Get.find<FriendsControllers>();
  final UserModel userInfo;

  UserProfileController(this.userInfo);

  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxList<UserModel> followers = <UserModel>[].obs;
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<StoryModel> stories = <StoryModel>[].obs;

  RxBool isLoading = true.obs;
  RxBool isFollowing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadFollowers();
    _loadPosts();
    _loadStories();
  }

  void toggleFollow() {
    friendsControllers.toggleFollow(targetUser: user.value!);

  }

  void _loadUser() {
    isLoading.value = true;
    FirebaseServices.firestore
        .collection('users')
        .doc(userInfo.uid)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              user.value = UserModel.fromJson(snapshot.data()!);
            }
            isLoading.value = false;
          },
          onError: (error) {
            debugPrint("Error loading user: $error");
            isLoading.value = false;
          },
        );

  }

  void _loadFollowers() {
    isLoading.value = true;

    FirebaseServices.firestore
        .collection('users')
        .doc(userInfo.uid)
        .collection("followers")
        .snapshots()
        .listen(
          (snapshot) {
            followers.value = snapshot.docs
                .map((e) => UserModel.fromJson(e.data()))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            debugPrint("Error loading user: $error");
            isLoading.value = false;
          },
        );
  }

  void _loadPosts() {
    isLoading.value = true;

    FirebaseServices.firestore
        .collection('users')
        .doc(userInfo.uid)
        .collection("posts")
        .snapshots()
        .listen(
          (snapshot) {
            posts.value = snapshot.docs
                .map((e) => PostModel.fromJson(e.data()))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            debugPrint("Error loading post: $error");
            isLoading.value = false;
          },
        );
  }

  void _loadStories() {
    isLoading.value = true;

    FirebaseServices.firestore
        .collection('users')
        .doc(userInfo.uid)
        .collection("stories")
        .snapshots()
        .listen(
          (snapshot) {
            stories.value = snapshot.docs
                .map((e) => StoryModel.fromJson(e.data()))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            debugPrint("Error loading story: $error");
            isLoading.value = false;
          },
        );
  }
}
