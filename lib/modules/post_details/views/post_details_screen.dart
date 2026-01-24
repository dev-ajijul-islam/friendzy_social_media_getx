import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/modules/post_details/views/full_image_screen.dart';
import 'package:friendzy_social_media_getx/widgets/comment_button.dart';
import 'package:friendzy_social_media_getx/widgets/like_button.dart';
import 'package:get/get.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  Widget _buildImageGrid(PostModel postModel) {
    final images = postModel.images ?? [];
    final imageCount = images.length;

    if (imageCount == 0) return const SizedBox();

    if (imageCount == 1) {
      return GestureDetector(
        onTap: () => _openFullScreenImage(images, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          ),
        ),
      );
    }

    if (imageCount == 2) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openFullScreenImage(images, 0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Image.network(images[0], fit: BoxFit.cover, height: 200),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: GestureDetector(
              onTap: () => _openFullScreenImage(images, 1),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.network(images[1], fit: BoxFit.cover, height: 200),
              ),
            ),
          ),
        ],
      );
    }

    if (imageCount == 3) {
      return Column(
        children: [
          GestureDetector(
            onTap: () => _openFullScreenImage(images, 0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _openFullScreenImage(images, 1),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.network(
                      images[1],
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: GestureDetector(
                  onTap: () => _openFullScreenImage(images, 2),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      images[2],
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (imageCount == 4) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _openFullScreenImage(images, index),
            child: ClipRRect(
              borderRadius: _getBorderRadius(index, 4),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
          );
        },
      );
    }

    return Stack(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openFullScreenImage(images, index),
              child: ClipRRect(
                borderRadius: _getBorderRadius(index, 4),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  height: 150,
                ),
              ),
            );
          },
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () => _openFullScreenImage(images, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black.withAlpha(50),
                child: Center(
                  child: Text(
                    '+${imageCount - 4}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BorderRadius _getBorderRadius(int index, int total) {
    if (total == 1) return BorderRadius.circular(10);
    if (total == 2) {
      return index == 0
          ? const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            )
          : const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            );
    }
    if (total == 3) {
      if (index == 0) {
        return const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        );
      } else if (index == 1) {
        return const BorderRadius.only(bottomLeft: Radius.circular(10));
      } else {
        return const BorderRadius.only(bottomRight: Radius.circular(10));
      }
    }
    if (total == 4) {
      if (index == 0) {
        return const BorderRadius.only(topLeft: Radius.circular(10));
      } else if (index == 1) {
        return const BorderRadius.only(topRight: Radius.circular(10));
      } else if (index == 2) {
        return const BorderRadius.only(bottomLeft: Radius.circular(10));
      } else {
        return const BorderRadius.only(bottomRight: Radius.circular(10));
      }
    }
    return BorderRadius.circular(0);
  }

  void _openFullScreenImage(List<String> images, int initialIndex) {
    Get.to(
      () => FullImageScreen(),
      arguments: {'images': images, 'initialIndex': initialIndex},
    );
  }

  @override
  Widget build(BuildContext context) {
    final PostModel postModel = Get.arguments;
    final Color primaryTeal = const Color(0xFF006680);

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
                  _buildMainPost(postModel, primaryTeal),
                  _buildCommentItem(
                    "Chris uil",
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra aliquam, congue habitasse tortor. Fringilla nunc aliquam volutpat suscipit porttitor in quis sagittis hac. Tellus sed ac libero",
                    "2hrs Ago",
                    "25",
                    "https://i.pravatar.cc/150?u=11",
                  ),
                  _buildCommentItem(
                    "Joe Mickey",
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra aliquam, congue habitasse tortor. Fringilla nunc aliquam volutpat suscipit porttitor in quis sagittis hac. Tellus sed ac libero",
                    "2hrs Ago",
                    "25",
                    "https://i.pravatar.cc/150?u=12",
                  ),
                  _buildCommentItem(
                    "General Focus",
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra aliquam, congue habitasse tortor. Fringilla nunc aliquam volutpat suscipit porttitor in quis sagittis hac. Tellus sed ac libero",
                    "2hrs Ago",
                    "25",
                    "https://i.pravatar.cc/150?u=13",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPost(PostModel postModel, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  postModel.author.profilePic ??
                      'https://i.pravatar.cc/150?u=5',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postModel.author.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '1hr ago',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            postModel.caption,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 12),
          _buildImageGrid(postModel),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(
                width: 50,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 9,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=1',
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?u=2',
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?u=3',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Liked by 100+',
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
              const Spacer(),
              LikeButton(post: postModel,),
              const SizedBox(width: 4),
              Text(
                postModel.likerIds!.length.toString(),
                style: TextStyle(fontSize: 11),
              ),
              const SizedBox(width: 12),
              CommentButton(),
              const SizedBox(width: 4),
              Text(
                postModel.commenterIds!.length.toString(),
                style: TextStyle(fontSize: 11),
              ),
            ],
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
