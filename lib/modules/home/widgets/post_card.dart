import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/post_details/views/full_image_screen.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/controllers/create_or_update_post_controller.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/views/create_or_upload_post_screen.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:friendzy_social_media_getx/utils/get_time_ago.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:friendzy_social_media_getx/widgets/comment_button.dart';
import 'package:friendzy_social_media_getx/widgets/like_button.dart';
import 'package:get/get.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, required this.postModel});
  final PostModel postModel;

  final CreateOrUpdatePostController createOrUpdatePostController =
      Get.find<CreateOrUpdatePostController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.postDetailsScreen, arguments: postModel),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(300),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(),
            const SizedBox(height: 12),
            _buildPostCaption(),
            const SizedBox(height: 12),
            _buildPostImages(),
            const SizedBox(height: 12),
            _buildPostActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            postModel.author.profilePic?.isNotEmpty == true
                ? postModel.author.profilePic!
                : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                postModel.author.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                getTimeAgo((postModel.createdAt)),
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz, size: 20),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                insetPadding: .zero,
                titlePadding: .symmetric(vertical: 15, horizontal: 20),
                title: Text("Take Action", style: Get.textTheme.titleMedium),
                contentPadding: .only(bottom: 20, left: 20, right: 20),
                content: Obx(
                  () => Column(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(10),
                        ),
                        tileColor: Colors.grey[200],
                        title: Text("Delete"),
                        trailing: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      ListTile(
                        onTap: () => Get.to(UploadPostScreen(isUpdate: true,existingPost: postModel,)),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(10),
                        ),

                        tileColor: Colors.grey[200],
                        title: Text("Edit"),
                        trailing: createOrUpdatePostController.inProcess.value
                            ? ButtonLoading()
                            : Icon(
                                Icons.edit_note_sharp,
                                color: Get.theme.colorScheme.secondary,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPostCaption() {
    if (postModel.caption.isEmpty) return const SizedBox();

    return Text(
      postModel.caption,
      style: const TextStyle(fontSize: 13, height: 1.5),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPostImages() {
    final images = postModel.images ?? [];
    final imageCount = images.length;

    if (imageCount == 0) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImageGrid(images),
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    final imageCount = images.length;

    switch (imageCount) {
      case 1:
        return _SingleImage(
          imageUrl: images[0],
          onTap: () => _openFullScreenImage(images, 0),
        );
      case 2:
        return _TwoImages(imageUrls: images);
      case 3:
        return _ThreeImages(imageUrls: images);
      case 4:
        return _FourImages(imageUrls: images);
      default:
        return _MultipleImages(imageUrls: images);
    }
  }

  Widget _buildPostActions() {
    final likesCount = postModel.likerIds?.length ?? 0;
    final commentsCount = postModel.commentsCount ?? 0;
    final currentUserId = FirebaseServices.auth.currentUser?.uid;
    final isLiked = postModel.likerIds?.contains(currentUserId) ?? false;
    final othersCount = isLiked ? likesCount - 1 : likesCount;

    return Column(
      children: [
        Row(
          children: [
            LikeButton(post: postModel),
            const SizedBox(width: 8),
            CommentButton(postModel: postModel),
            const Spacer(),
            if (likesCount > 0)
              Text(
                isLiked
                    ? "You${' + $othersCount others'}"
                    : '$likesCount likes',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            if (likesCount < 1)
              Text(
                "No likes here",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
          ],
        ),
        const SizedBox(height: 8),

        commentsCount > 0
            ? Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'View all $commentsCount comments',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'No comments yet',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
}

// Single Image
class _SingleImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _SingleImage({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      ),
    );
  }
}

// Two Images
class _TwoImages extends StatelessWidget {
  final List<String> imageUrls;

  const _TwoImages({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.to(
              () => FullImageScreen(),
              arguments: {'images': imageUrls, 'initialIndex': 0},
            ),
            child: Image.network(imageUrls[0], fit: BoxFit.cover, height: 200),
          ),
        ),
        Container(width: 1, color: Colors.white),
        Expanded(
          child: GestureDetector(
            onTap: () => Get.to(
              () => FullImageScreen(),
              arguments: {'images': imageUrls, 'initialIndex': 1},
            ),
            child: Image.network(imageUrls[1], fit: BoxFit.cover, height: 200),
          ),
        ),
      ],
    );
  }
}

// Three Images
class _ThreeImages extends StatelessWidget {
  final List<String> imageUrls;

  const _ThreeImages({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(
            () => FullImageScreen(),
            arguments: {'images': imageUrls, 'initialIndex': 0},
          ),
          child: Image.network(
            imageUrls[0],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        ),
        Container(height: 1, color: Colors.white),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Get.to(
                  () => FullImageScreen(),
                  arguments: {'images': imageUrls, 'initialIndex': 1},
                ),
                child: Image.network(
                  imageUrls[1],
                  fit: BoxFit.cover,
                  height: 150,
                ),
              ),
            ),
            Container(width: 1, color: Colors.white),
            Expanded(
              child: GestureDetector(
                onTap: () => Get.to(
                  () => FullImageScreen(),
                  arguments: {'images': imageUrls, 'initialIndex': 2},
                ),
                child: Image.network(
                  imageUrls[2],
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
}

// Four Images
class _FourImages extends StatelessWidget {
  final List<String> imageUrls;

  const _FourImages({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Get.to(
            () => FullImageScreen(),
            arguments: {'images': imageUrls, 'initialIndex': index},
          ),
          child: Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
            height: 150,
          ),
        );
      },
    );
  }
}

// Multiple Images (5+)
class _MultipleImages extends StatelessWidget {
  final List<String> imageUrls;

  const _MultipleImages({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Get.to(
                () => FullImageScreen(),
                arguments: {'images': imageUrls, 'initialIndex': index},
              ),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
            if (index == 3 && imageUrls.length > 4)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha(500),
                  child: Center(
                    child: Text(
                      '+${imageUrls.length - 4}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
