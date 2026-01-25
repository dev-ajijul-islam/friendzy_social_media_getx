import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:get/get.dart';

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
              // ---------------- STORY IMAGE ----------------
              Positioned.fill(child: _buildStoryImage(story!)),

              // ---------------- TOP GRADIENT ----------------
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

              SafeArea(
                child: Column(
                  children: [
                    // ---------------- PROGRESS BAR ----------------
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

                    // ---------------- USER INFO ----------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              user!.author.profilePic.toString(),
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
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                story.viewers.length.toString(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: controller.react,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Get.back(),
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

                    const SizedBox(height: 10),

                    // ---------------- COMMENT BOX ----------------
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

              // ---------------- TAP ZONES ----------------
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
            ],
          ),
        );
      }),
    );
  }

  // ---------------- STORY IMAGE BUILDER ----------------
  Widget _buildStoryImage(StoryItem story) {
    final images = story.images;

    if (images.isEmpty) return const SizedBox();
    if (images.length == 1) {
      return Image.network(
        images[0],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (images.length == 2) {
      return Row(
        children: images
            .map(
              (img) => Expanded(child: Image.network(img, fit: BoxFit.cover)),
            )
            .toList(),
      );
    }

    // For 3 or more images
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: images.length > 4 ? 4 : images.length,
      itemBuilder: (context, index) {
        return Image.network(images[index], fit: BoxFit.cover);
      },
    );
  }
}
