import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/home/widgets/post_card.dart';
import 'package:get/get.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostModel postModel = Get.arguments;

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
      body: Column(
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                    "2hrs Ago",
                    "25",
                    "https://i.pravatar.cc/150?u=11",
                  ),
                ],
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
