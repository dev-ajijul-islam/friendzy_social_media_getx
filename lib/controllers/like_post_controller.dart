import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class LikePostController extends GetxController {
  RxBool isLoading = false.obs;

  final String userId = FirebaseServices.auth.currentUser!.uid;

  Future<void> toggleLike({required PostModel post, required bool isMe}) async {
    isMe
        ? await FirebaseServices.firestore
              .collection("users")
              .doc(post.author.uid)
              .collection("posts")
              .doc(post.postId)
              .update({
                "likerIds": FieldValue.arrayRemove([userId]),
              })
        : await FirebaseServices.firestore
              .collection("users")
              .doc(post.author.uid)
              .collection("posts")
              .doc(post.postId)
              .update({
                "likerIds": FieldValue.arrayUnion([userId]),
              });
  }
}
