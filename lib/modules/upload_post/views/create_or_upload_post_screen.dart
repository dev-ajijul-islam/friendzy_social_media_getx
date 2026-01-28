import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/controllers/image_upload_controller.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/controllers/create_or_update_post_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UploadPostScreen extends StatelessWidget {
  final bool isUpdate;
  final PostModel? existingPost;

  UploadPostScreen({super.key, required this.isUpdate, this.existingPost});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final CreateOrUpdatePostController controller =
    Get.find<CreateOrUpdatePostController>();
    final ImageUploadController imageUploadController =
    Get.find<ImageUploadController>();

    if (isUpdate && existingPost != null) {
      controller.captionController.text = existingPost!.caption;
      controller.hashTags.assignAll(existingPost!.hashTags ?? []);
      controller.images.assignAll(existingPost!.images ?? []);
    }

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
          'Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: controller.postFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildLabel("Select Image(s)"),

              // Images Grid
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF006680).withOpacity(0.3)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Obx(
                            () => GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: controller.images.length,
                          itemBuilder: (context, index) {
                            final image = controller.images[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                errorWidget: (context, url, error) => const Icon(Icons.image),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: InkWell(
                        onTap: () {
                          imageUploadController.uploadImage(reason: Reason.post);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF006680)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Color(0xFF006680), size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildLabel("Add Caption"),
              _buildInputField(
                hint: "Type Cption for post",
                controller.captionController,
                    (value) => value!.isEmpty ? "Enter caption here..." : null,
                maxLines: 4,
              ),

              const SizedBox(height: 24),
              _buildLabel("Add Hashtags"),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller.hashTagController,
                          (_) => null,
                      hint: "Add tag",
                      onSubmit: (_) => controller.addTag(),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.addTag,
                    icon: const Icon(Icons.add, color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(colorScheme.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Tags Chips
              Obx(
                    () => SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.hashTags.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => controller.removeTag(index),
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(controller.hashTags[index]),
                            const SizedBox(width: 4),
                            const Icon(Icons.close, size: 14, color: Colors.grey),
                          ],
                        ),
                        backgroundColor: colorScheme.secondary.withAlpha(100),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Create/Update Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                      () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006680),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: controller.inProcess.value
                        ? null
                        : () => controller.createOrUpdatePost(
                      existingPost: existingPost,
                      isUpdate: isUpdate,
                    ),
                    child: controller.inProcess.value
                        ? const ButtonLoading()
                        : Text(
                      isUpdate ? "Update" : "Create",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400)),
    );
  }

  Widget _buildInputField(
      TextEditingController controller,
      FormFieldValidator? validator, {
        required String hint,
        int maxLines = 1,
        ValueChanged<String>? onSubmit,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
