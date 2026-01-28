import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/post_details/controllers/full_image_view_controller.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullImageScreen extends StatelessWidget {
  const FullImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final List<String> images = List<String>.from(args['images'] ?? []);
    final int initialIndex = args['initialIndex'] ?? 0;

    final FullImageViewController controller = Get.put(
      FullImageViewController(),
      tag: 'fullImageViewer_${DateTime.now().millisecondsSinceEpoch}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialIndex.value = initialIndex;
      controller.currentIndex.value = initialIndex;
      if (controller.pageController.hasClients) {
        controller.pageController.jumpToPage(initialIndex);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(
              () => Text(
            '${controller.currentIndex.value + 1}/${images.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                controller.currentIndex.value = index;
              },
              itemBuilder: (context, index) {
                final imageUrl = images[index];

                return PhotoView(
                  imageProvider: CachedNetworkImageProvider(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: 'image_$imageUrl$index',
                  ),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  loadingBuilder: (context, event) {
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 40,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (images.length > 1)
            Obx(
                  () => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentIndex.value == index
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
