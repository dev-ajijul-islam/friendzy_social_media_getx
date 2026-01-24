import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/comment_model.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/home/widgets/post_card.dart';
import 'package:friendzy_social_media_getx/modules/post_details/controllers/create_comment_controller.dart';
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
                      _buildCommentItem(
                        "Chris uil",
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra aliquam, congue habitasse tortor. Fringilla nunc aliquam volutpat suscipit porttitor in quis sagittis hac. Tellus sed ac libero",
                        "2 hrs Ago",
                        "25",
                        "https://i.pravatar.cc/150?u=11",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                              comment: commentController.commentTEController.text,
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

  Widget _buildCommentItem(
    String name,
    String comment,
    String time,
    String likes,
    String img,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(img)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      likes,
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
