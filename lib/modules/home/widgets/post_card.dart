import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.postModel});
  final PostModel postModel;

  Widget _buildImageGrid() {
    final images = postModel.images ?? [];
    final imageCount = images.length;

    if (imageCount == 0) return SizedBox();

    if (imageCount == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          images[0].toString(),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
        ),
      );
    }

    if (imageCount == 2) {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                images[0].toString(),
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Image.network(
                images[1].toString(),
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
        ],
      );
    }

    if (imageCount == 3) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              images[0].toString(),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Image.network(
                    images[1].toString(),
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    images[2].toString(),
                    fit: BoxFit.cover,
                    height: 150,
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
          return ClipRRect(
            borderRadius: _getBorderRadius(index, 4),
            child: Image.network(
              images[index].toString(),
              fit: BoxFit.cover,
              height: 150,
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
            return ClipRRect(
              borderRadius: _getBorderRadius(index, 4),
              child: Image.network(
                images[index].toString(),
                fit: BoxFit.cover,
                height: 150,
              ),
            );
          },
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.postDetailsScreen),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100]!.withAlpha(500),
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
                      '1hr ago',
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
            _buildImageGrid(),

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
                const Icon(Icons.favorite, color: Colors.red, size: 18),
                const SizedBox(width: 4),
                Text(
                  postModel.likerIds!.length.toString(),
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 15),
                const Icon(Icons.chat_bubble, color: Colors.black, size: 18),
                const SizedBox(width: 4),
                Text(
                  postModel.commenterIds!.length.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'View all 57 comments',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
