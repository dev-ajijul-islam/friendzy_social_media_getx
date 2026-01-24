import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class GetMyPostsController extends GetxController {
  RxBool isLoading = true.obs;
  List<PostModel> myPosts = <PostModel>[].obs;

  @override
  void onInit() {
    getMyPosts();
    super.onInit();
  }

  void getMyPosts(){
    FirebaseServices.firestore
        .collection("users")
        .doc(FirebaseServices.auth.currentUser?.uid)
        .collection("posts")
        .snapshots()
        .listen((snapshot) {
          myPosts = snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data()))
              .toList();
          isLoading.value = false;
        });
  }
}
