import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/home/controllers/get_all_post_controller.dart';
import 'package:friendzy_social_media_getx/modules/home/widgets/post_card.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final GetAllPostController postController =
        Get.find<GetAllPostController>();
    final StoryController storyController = Get.put(StoryController());

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            _buildTopSection(colorScheme),

            const SizedBox(height: 20),

            _buildStoriesSection(storyController),

            _buildFeedSection(colorScheme, postController),
          ],
        ),
      ),
    );
  }

  // ---------------- TOP SEARCH ----------------

  Widget _buildTopSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF006680), width: 1),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Type something ......',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF006680)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.notificationScreen);
            },
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 28,
              color: Color(0xFF006680),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- STORIES (REAL DATA) ----------------

  Widget _buildStoriesSection(StoryController controller) {
    return Obx(() {
      if (controller.storiesByUser.isEmpty) {
        return const SizedBox();
      }

      return SizedBox(
        height: 220,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 15),
          scrollDirection: Axis.horizontal,
          itemCount: controller.storiesByUser.length,
          itemBuilder: (context, index) {
            final storyModel = controller.storiesByUser[index];
            final author = storyModel.author;

            return GestureDetector(
              onTap: () {
                // Set selected user
                controller.currentUserIndex.value = index;
                controller.currentStoryIndex.value = 0;

                Get.toNamed(AppRoutes.storyDetailsScreen);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 95,
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                            image: storyModel.stories.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                      storyModel.stories.first.image,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),

                        // Avatar
                        Positioned(
                          bottom: -15,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundImage: NetworkImage(author.fullName),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      author.fullName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ---------------- FEED ----------------

  Widget _buildFeedSection(
    ColorScheme colorScheme,
    GetAllPostController postController,
  ) {
    return Obx(() {
      if (postController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (postController.posts.isEmpty) {
        return const Center(child: Text("There is no post yet"));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: postController.posts.length,
        itemBuilder: (context, index) {
          final post = postController.posts[index];
          return PostCard(postModel: post);
        },
      );
    });
  }
}
