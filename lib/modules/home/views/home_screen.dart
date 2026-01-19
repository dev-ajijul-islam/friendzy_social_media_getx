import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            _buildTopSection(colorScheme),

            const SizedBox(height: 20),

            _buildStoriesSection(),

            _buildFeedSection(colorScheme),
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
           child:  Padding(
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

  Widget _buildFeedSection(ColorScheme colorScheme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return _buildPostCard(colorScheme);
      },
    );
  }

  Widget _buildPostCard(ColorScheme colorScheme) {
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
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=5',
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oyin Dolapo',
                      style: TextStyle(
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
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              clipBehavior: .hardEdge,
              decoration: BoxDecoration(
                border: .all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
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
                const Icon(Icons.favorite, color: Colors.red, size: 18),
                const SizedBox(width: 4),
                const Text('247', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 15),
                const Icon(Icons.chat_bubble, color: Colors.black, size: 18),
                const SizedBox(width: 4),
                const Text('57', style: TextStyle(fontSize: 12)),
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
