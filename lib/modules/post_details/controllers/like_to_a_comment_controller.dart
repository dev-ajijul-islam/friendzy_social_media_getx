import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendzy_social_media_getx/data/models/comment_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class LikeToACommentController extends GetxController {
  RxBool isLoading = false.obs;

  final String userId = FirebaseServices.auth.currentUser!.uid;

  Future<void> toggleLikeToComment({
    required CommentModel comment,
    required bool isMe,
  }) async {
    isMe
        ? await FirebaseServices.firestore
              .collection("users")
              .doc(comment.postAuthor.uid)
              .collection("posts")
              .doc(comment.postId)
              .collection("comments")
              .doc(comment.commentId)
              .update({
                "likerIds": FieldValue.arrayRemove([userId]),
              })
        : await FirebaseServices.firestore
              .collection("users")
              .doc(comment.postAuthor.uid)
              .collection("posts")
              .doc(comment.postId)
              .collection("comments")
              .doc(comment.commentId)
              .update({
                "likerIds": FieldValue.arrayUnion([userId]),
              });
  }
}
