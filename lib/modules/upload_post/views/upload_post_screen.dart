import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/controllers/post_upload_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';

class UploadPostScreen extends StatelessWidget {
  const UploadPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final PostUploadController controller = Get.find<PostUploadController>();

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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF006680).withOpacity(0.3),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF006680)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF006680),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildLabel("Add caption"),
              _buildInputField(
                hint: "",
                maxLines: 4,
                controller.captionController,
                (value) {
                  if (value.isEmpty) {
                    return "Enter Caption here..";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _buildLabel("Add hastags"),
              _buildInputField(hint: "", controller.hashTagController, (value) {
                if (value.isEmpty) {
                  return "Enter a Tags here..";
                }
                return null;
              }),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006680),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: controller.inProcess.value
                        ? null
                        : controller.createPost,
                    child: controller.inProcess.value
                        ? ButtonLoading()
                        : Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

  // Label Widget
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    FormFieldValidator? validator, {
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: maxLines,
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
