import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/home/controllers/get_all_post_controller.dart';
import 'package:friendzy_social_media_getx/modules/home/widgets/post_card.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final GetAllPostController postController =
        Get.find<GetAllPostController>();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            _buildTopSection(colorScheme),

            const SizedBox(height: 20),

            _buildStoriesSection(),

            _buildFeedSection(colorScheme, postController),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .center,
        spacing: 10,
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

  Widget _buildStoriesSection() {
    final List<Map<String, String>> stories = [
      {'name': 'Abdul', 'image': '', 'isMe': 'true'},
      {
        'name': 'Chris',
        'image': 'https://i.pravatar.cc/150?u=1',
        'isLive': 'true',
      },
      {'name': 'General', 'image': 'https://i.pravatar.cc/150?u=2'},
      {'name': 'Ojogbon', 'image': 'https://i.pravatar.cc/150?u=3'},
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 15),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.storyDetailsScreen),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: .none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 95,
                        height: 160,
                        decoration: BoxDecoration(
                          border: .all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                          image: story['image'] != ''
                              ? DecorationImage(
                                  image: NetworkImage(story['image']!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: story['isMe'] == 'true'
                            ? const Center(
                                child: Icon(Icons.add, color: Colors.black),
                              )
                            : null,
                      ),
                      if (story['isLive'] == 'true')
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: -15,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 17,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/150?u=9',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    story['name']!,
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
  }

  Widget _buildFeedSection(
    ColorScheme colorScheme,
    GetAllPostController postController,
  ) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: postController.posts.length,
        itemBuilder: (context, index) {
          final post = postController.posts[index];
          return PostCard(postModel: post);
        },
      ),
    );
  }
}
