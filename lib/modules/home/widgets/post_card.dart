import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/modules/post_details/views/full_image_screen.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:friendzy_social_media_getx/utils/get_time_ago.dart';
import 'package:friendzy_social_media_getx/widgets/comment_button.dart';
import 'package:friendzy_social_media_getx/widgets/like_button.dart';
import 'package:get/get.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.postModel});
  final PostModel postModel;

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

  void _openFullScreenImage(List<String> images, int initialIndex) {
    Get.to(
      () => FullImageScreen(),
      arguments: {'images': images, 'initialIndex': initialIndex},
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.postDetailsScreen, arguments: postModel),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
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
                    postModel.author.profilePic.toString(),
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
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      getTimeAgo((postModel.createdAt)),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              postModel.caption,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: .new(color: Colors.black),
                borderRadius: .circular(10),
              ),
              child: _buildImageGrid(postModel),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(
                  width: 60,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?u=11',
                        ),
                      ),
                      Positioned(
                        left: 12,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?u=12',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?u=13',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Liked by you 100+ others',
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                ),
                const Spacer(),
                LikeButton(post: postModel),
                const SizedBox(width: 4),
                Text(
                  postModel.likerIds!.length.toString(),
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 15),
                CommentButton(postModel: postModel),
                const SizedBox(width: 4),
                Text(
                  postModel.commentsCount.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'View all ${postModel.commentsCount.toString()} comments',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
