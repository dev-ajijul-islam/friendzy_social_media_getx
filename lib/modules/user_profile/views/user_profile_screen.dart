import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/views/edit_profile_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context, "Abdul Qudus", "Abeokuta, Ogun", true),
            _buildStatsSection(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Followers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            _buildFollowersList(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Posts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            _buildPostsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    String name,
    String loc,
    bool isOther,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=11'),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      loc,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (isOther) ...[
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {},
                ),
              ],
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "I'm a postive person. I love to travel and eat. Always available for chat",
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 15),
          if (isOther)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chat_bubble_outline, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Follow',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Get.to(() => const EditProfileScreen()),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem("87", "Posts"),
          _verticalDivider(),
          _statItem("870", "Following"),
          _verticalDivider(),
          _statItem("15k", "Followers"),
        ],
      ),
    );
  }

  Widget _statItem(String count, String label) => Column(
    children: [
      Text(
        count,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    ],
  );

  Widget _verticalDivider() =>
      Container(height: 30, width: 1, color: Colors.grey.shade300);

  Widget _buildFollowersList() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=$index',
                ),
              ),
              const SizedBox(height: 4),
              const Text('User', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          'https://picsum.photos/200?random=$index',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
