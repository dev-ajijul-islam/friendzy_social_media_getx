import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/controllers/image_upload_controller.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddStoryScreen extends StatelessWidget {
  const AddStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageUploadController imageUploadController =
    Get.find<ImageUploadController>();
    final StoryController storyController = Get.find<StoryController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Add Story"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // ---------------- IMAGE PREVIEW ----------------
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[900],
              child: Obx(() {
                if (storyController.selectedImages.isEmpty) {
                  return const Center(
                    child: Icon(Icons.image_outlined, size: 120, color: Colors.white38),
                  );
                }
                return _buildImageGrid(storyController.selectedImages);
              }),
            ),
          ),

          // ---------------- CAPTION & ACTIONS ----------------
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Caption", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: storyController.captionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Write something about your story...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Add Image Button
                Align(
                  child: GestureDetector(
                    onTap: () => imageUploadController.isUploading.value
                        ? null
                        : imageUploadController.uploadImage(reason: Reason.story),
                    child: CircleAvatar(
                      backgroundColor: Get.theme.colorScheme.secondary,
                      radius: 40,
                      child: const Icon(Icons.add_photo_alternate, size: 35),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Post Story Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(
                        () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006680),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: storyController.isLoading.value ? null : _submitStory(storyController),
                      child: storyController.isLoading.value
                          ? const ButtonLoading()
                          : const Text(
                        "Post Story",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  // ---------------- IMAGE GRID ----------------
  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return _singleImage(images[0]);
    } else if (images.length == 2) {
      return _twoImages(images);
    } else if (images.length == 3) {
      return _threeImages(images);
    } else {
      return _multiImages(images);
    }
  }

  Widget _singleImage(String url) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
  );

  Widget _twoImages(List<String> urls) => Row(
    children: urls.map((url) {
      int idx = urls.indexOf(url);
      return Expanded(
        child: ClipRRect(
          borderRadius: idx == 0
              ? const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              : const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
          child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
        ),
      );
    }).toList(),
  );

  Widget _threeImages(List<String> urls) => Column(
    children: [
      Expanded(child: _singleImage(urls[0])),
      const SizedBox(height: 2),
      Expanded(
        child: Row(
          children: [
            Expanded(child: _singleImage(urls[1])),
            const SizedBox(width: 2),
            Expanded(child: _singleImage(urls[2])),
          ],
        ),
      ),
    ],
  );

  Widget _multiImages(List<String> urls) {
    final displayCount = urls.length > 4 ? 4 : urls.length;
    return Stack(
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: displayCount,
          itemBuilder: (_, idx) => ClipRRect(
            borderRadius: _getBorderRadius(idx, displayCount),
            child: CachedNetworkImage(imageUrl: urls[idx], fit: BoxFit.cover),
          ),
        ),
        if (urls.length > 4)
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(400),
              child: Center(
                child: Text(
                  '+${urls.length - 4}',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }

  BorderRadius _getBorderRadius(int index, int total) {
    switch (index) {
      case 0:
        return const BorderRadius.only(topLeft: Radius.circular(10));
      case 1:
        return const BorderRadius.only(topRight: Radius.circular(10));
      case 2:
        return const BorderRadius.only(bottomLeft: Radius.circular(10));
      case 3:
        return const BorderRadius.only(bottomRight: Radius.circular(10));
      default:
        return BorderRadius.zero;
    }
  }

  // ---------------- SUBMIT ----------------
  VoidCallback _submitStory(StoryController storyController) {
    return () {
      if (storyController.captionController.text.trim().isEmpty) {
        Get.snackbar(
          "Missing Caption",
          "Please write a caption for your story",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      storyController.createStory();
    };
  }
}
