import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryDetailsScreen extends StatelessWidget {
  const StoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Background Image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1513104890138-7c749659a591', // Pizza image
              fit: BoxFit.cover,
            ),
          ),

          // 2. Dark Overlay at the top for visibility
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

          // 3. Main UI Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Progress Bars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      _buildProgressBar(isCompleted: true),
                      const SizedBox(width: 5),
                      _buildProgressBar(isCompleted: false, progress: 0.6),
                      const SizedBox(width: 5),
                      _buildProgressBar(isCompleted: false),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // User Info & Close Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=5'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Oyin Dolapo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '1hr ago',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 4. Floating Comment Input
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a comment',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Top Progress Indicators
  Widget _buildProgressBar({bool isCompleted = false, double progress = 0.0}) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: isCompleted ? 1.0 : progress,
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted || progress > 0 ? const Color(0xFF006680) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}