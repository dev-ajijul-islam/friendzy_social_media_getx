import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/comment_model.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/home/widgets/post_card.dart';
import 'package:friendzy_social_media_getx/modules/post_details/controllers/create_comment_controller.dart';
import 'package:friendzy_social_media_getx/modules/post_details/controllers/like_to_a_comment_controller.dart';
import 'package:friendzy_social_media_getx/utils/get_time_ago.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';

class PostDetailsScreen extends StatelessWidget {
  PostDetailsScreen({super.key});

  final CreateCommentController commentController =
      Get.find<CreateCommentController>();

  @override
  Widget build(BuildContext context) {
    final PostModel postModel = Get.arguments;

    final currentUser = FirebaseServices.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Comment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: .bottomCenter,
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseServices.firestore
                            .collection("users")
                            .doc(postModel.author.uid)
                            .collection("posts")
                            .doc(postModel.postId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError || !snapshot.hasData) {
                            return Center(child: Text("Post not found"));
                          }

                          final post = PostModel.fromJson({
                            ...snapshot.data!.data()!,
                            "postId": snapshot.data?.id,
                          });

                          return PostCard(postModel: post);
                        },
                      ),
                      StreamBuilder(
                        stream: FirebaseServices.firestore
                            .collection("users")
                            .doc(postModel.author.uid)
                            .collection("posts")
                            .doc(postModel.postId)
                            .collection("comments")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError || !snapshot.hasData) {
                            return Center(child: Text("Something went wrong"));
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(height: 50),
                                Center(child: Text("No comment yet")),
                              ],
                            );
                          }

                          return Column(
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                final CommentModel comment =
                                    CommentModel.fromJson({
                                      ...snapshot.data!.docs[index].data(),
                                      "commentId":
                                          snapshot.data?.docs[index].id,
                                    });

                                return _buildCommentItem(comment: comment);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
          Positioned(
            child: Container(
              color: Colors.grey[200],
              child: Form(
                key: commentController.commentFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: commentController.commentTEController,
                        decoration: InputDecoration(
                          hintText: 'Type your comment...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Obx(
                      () => IconButton(
                        onPressed: () {
                          if (!commentController.isLoading.value &&
                              commentController.commentTEController.text
                                  .trim()
                                  .isNotEmpty) {
                            final comment = CommentModel(
                              commentAuthor: UserModel(
                                fullName: currentUser!.displayName.toString(),
                                email: currentUser.email.toString(),
                                uid: currentUser.uid,
                                profilePic: currentUser.photoURL,
                              ),
                              postAuthor: postModel.author,
                              postId: postModel.postId.toString(),
                              comment:
                                  commentController.commentTEController.text,
                              likerIds: [],
                              createdAt: DateTime.now(),
                            );
                            commentController.createComment(comment: comment);
                          }
                        },
                        icon: commentController.isLoading.value
                            ? ButtonLoading()
                            : Icon(Icons.send, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem({required CommentModel comment}) {
    final LikeToACommentController likeToACommentController =
        Get.find<LikeToACommentController>();

    final isMe = comment.likerIds.contains(
      FirebaseServices.auth.currentUser!.uid,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              comment.commentAuthor.profilePic.toString(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.commentAuthor.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      getTimeAgo(comment.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        likeToACommentController.toggleLikeToComment(
                          comment: comment,
                          isMe: isMe,
                        );
                      },
                      icon: Icon(
                        isMe ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      comment.likerIds.length.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
