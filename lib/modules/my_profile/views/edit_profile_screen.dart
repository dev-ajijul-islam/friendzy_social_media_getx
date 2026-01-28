import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/controllers/image_upload_controller.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key}) {
    Get.put(MyProfileController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyProfileController>();
    final ImageUploadController uploadController =
        Get.find<ImageUploadController>();
    const Color primaryTeal = Color(0xFF006680);

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
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isProfileInfoLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          uploadController.uploadImage(reason: Reason.profile),

                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: null,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                controller.userInfo.value.profilePic ??
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(strokeWidth: 2),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Form Fields
              _buildLabel("Username"),
              _buildInputField(
                controller: controller.usernameController,
                hint: "Enter your username",
                onChanged: (value) => controller.updateField('username', value),
              ),

              _buildLabel("Full Name"),
              _buildInputField(
                controller: controller.fullNameController,
                hint: "Enter your full name",
                readOnly: false,
              ),

              _buildLabel("Email"),
              _buildInputField(
                controller: TextEditingController(
                  text: controller.userInfo.value.email,
                ),
                hint: "Enter your email",
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
              ),

              _buildLabel("Region"),
              _buildInputField(
                controller: controller.regionController,
                hint: "Enter your region (e.g., Abeokuta, Ogun)",
                onChanged: (value) => controller.updateField('region', value),
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Phone Number"),
                        _buildInputField(
                          controller: controller.phoneNumberController,
                          hint: "09012345678",
                          keyboardType: TextInputType.phone,
                          onChanged: (value) =>
                              controller.updateField('phoneNumber', value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Gender"),
                        // Gender Dropdown
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue:
                                controller.genderController.text.isNotEmpty
                                ? controller.genderController.text
                                : null,
                            decoration: InputDecoration(
                              hintText: "Select gender",
                              hintStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            items: controller.genderOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.genderController.text = newValue;
                                controller.updateField('gender', newValue);
                              }
                            },
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black54,
                            ),
                            dropdownColor: Colors.white,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              _buildLabel("Bio"),
              _buildInputField(
                controller: controller.bioController,
                hint: "Tell us about yourself...",
                maxLines: 4,
                onChanged: (value) => controller.updateField('bio', value),
              ),
              SizedBox(height: 30),
              // Update Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: controller.isUpdating.value
                        ? null
                        : () async {
                            if (controller.validateForm()) {
                              final success = await controller.saveProfile();
                              if (success) {
                                Get.back();
                              }
                            }
                          },
                    child: controller.isUpdating.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Update Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Helper widget for Input Fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        filled: true,
        fillColor: readOnly ? Color(0xFFF5F5F5) : Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
