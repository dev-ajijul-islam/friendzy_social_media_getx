import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryDetailsScreen extends StatelessWidget {
  StoryDetailsScreen({super.key});

  final StoryController controller = Get.put(StoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final user = controller.currentUser;
        final story = controller.currentStory;

        final isMe = user?.story.reactors.any(
              (u) => u.uid == FirebaseServices.auth.currentUser!.uid,
        );

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < 0) {
                controller.nextUser();
              } else if (details.primaryVelocity! > 0) {
                controller.previousUser();
              }
            }
          },
          child: Stack(
            children: [
              Positioned.fill(child: _buildStoryImage(story!)),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 220,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: controller.progress.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              user!.author.profilePic?.isNotEmpty == true
                                  ? user.author.profilePic!
                                  : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            user.author.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    if (story.captions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            story.captions,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Send a message",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Icon(Icons.send, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.previousUser,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.nextUser,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 120,
                right: 10,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      story.viewers.length.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 15),
                    IconButton(
                      icon: controller.isReacting.value
                          ? ButtonLoading()
                          : Icon(
                        isMe! ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.red,
                      ),
                      onPressed: () => controller.isReacting.value
                          ? null
                          : controller.react(isMe!),
                    ),
                    Text(
                      story.reactors.length.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _cachedImage(String url,
      {double? height, double? width, BoxFit fit = BoxFit.cover}) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, _) => Container(
        color: Colors.grey[900],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, _, __) => Container(
        color: Colors.grey[800],
        child: const Icon(Icons.broken_image, color: Colors.white70, size: 40),
      ),
    );
  }

  Widget _buildStoryImage(StoryItem story) {
    final images = story.images.where((e) => e.isNotEmpty).toList();

    if (images.isEmpty) return const SizedBox();

    switch (images.length) {
      case 1:
        return _cachedImage(
          images[0],
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        );
      case 2:
        return Row(
          children: [
            Expanded(
              child: _cachedImage(images[0],
                  fit: BoxFit.cover, height: double.infinity),
            ),
            Container(width: 2, color: Colors.black),
            Expanded(
              child: _cachedImage(images[1],
                  fit: BoxFit.cover, height: double.infinity),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            Expanded(
              child: _cachedImage(images[0],
                  fit: BoxFit.cover, width: double.infinity),
            ),
            Container(height: 2, color: Colors.black),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _cachedImage(images[1],
                        fit: BoxFit.cover, height: double.infinity),
                  ),
                  Container(width: 2, color: Colors.black),
                  Expanded(
                    child: _cachedImage(images[2],
                        fit: BoxFit.cover, height: double.infinity),
                  ),
                ],
              ),
            ),
          ],
        );
      case 4:
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _cachedImage(images[index], fit: BoxFit.cover);
          },
        );
      default:
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                _cachedImage(images[index], fit: BoxFit.cover),
                if (index == 3)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      child: Center(
                        child: Text(
                          '+${images.length - 4}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
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
}
