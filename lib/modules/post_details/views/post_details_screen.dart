import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildMainPost(primaryTeal),

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

  Widget _buildMainPost(Color primaryColor) {
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
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=5'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Oyin Dolapo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra',
            style: TextStyle(fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
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
              const Icon(Icons.favorite, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              const Text('247', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 12),
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.black,
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text('57', style: TextStyle(fontSize: 11)),
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
