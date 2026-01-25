import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class GetMyStoriesControllers extends GetxController {
  RxBool isLoading = true.obs;
  List<StoryModel> myStories = <StoryModel>[].obs;

  @override
  void onInit() {
    getMyPosts();
    super.onInit();
  }

  void getMyPosts() {
    FirebaseServices.firestore
        .collection("users")
        .doc(FirebaseServices.auth.currentUser?.uid)
        .collection("stories")
        .snapshots()
        .listen((snapshot) {
          myStories = snapshot.docs
              .map(
                (doc) =>
                    StoryModel.fromJson({...doc.data(), "storyId": doc.id}),
              )
              .toList();
          isLoading.value = false;
        });
  }
}
