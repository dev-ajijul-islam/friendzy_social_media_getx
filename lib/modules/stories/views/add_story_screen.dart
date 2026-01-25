import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/controllers/image_upload_controller.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final ImageUploadController imageUploadController =
      Get.find<ImageUploadController>();
  final StoryController storyController = Get.find<StoryController>();

  @override
  Widget build(BuildContext context) {
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
          // ---------------- PREVIEW AREA ----------------
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[900],
              child: Obx(() {
                if (storyController.selectedImages.isEmpty) {
                  return const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 120,
                      color: Colors.white38,
                    ),
                  );
                }
                return _buildImagePreviewGrid(storyController.selectedImages);
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
                const Text(
                  "Caption",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
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
                Align(
                  child: GestureDetector(
                    onTap: () => imageUploadController.isUploading.value
                        ? null
                        : imageUploadController.uploadImage(
                            reason: Reason.story,
                          ),
                    child: CircleAvatar(
                      backgroundColor: Get.theme.colorScheme.secondary,
                      radius: 40,
                      child: Icon(Icons.add_photo_alternate, size: 35),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006680),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => storyController.isLoading.value
                          ? null
                          : submitStory(),
                      child: storyController.isLoading.value
                          ? ButtonLoading()
                          : Text(
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

  // ---------------- ACTION BUTTON ----------------
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ---------------- SUBMIT HANDLER ----------------
  void submitStory() {
    if (storyController.captionController.text.trim().isEmpty) {
      Future.delayed(const Duration(milliseconds: 800), () {
        Get.back();
      });

      Get.snackbar(
        "Missing Caption",
        "Please write a caption for your story",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    storyController.createStory();
  }

  // ---------------- IMAGE GRID PREVIEW ----------------
  Widget _buildImagePreviewGrid(List<String> images) {
    final count = images.length;

    if (count == 1) {
      return GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      );
    }

    if (count == 2) {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Image.network(
                images[1],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
        ],
      );
    }

    if (count == 3) {
      return Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.network(
                      images[1],
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      images[2],
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // 4 or more images
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
          itemCount: count > 4 ? 4 : count,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: _getBorderRadius(index, 4),
              child: Image.network(images[index], fit: BoxFit.cover),
            );
          },
        ),
        if (count > 4)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Text(
                  '+${count - 4}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
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
}
