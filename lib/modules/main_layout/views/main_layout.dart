import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/views/create_or_upload_post_screen.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  MainLayout({super.key});

  final MainLayoutController controller = Get.find<MainLayoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: Obx(() => controller.screens[controller.selectedIndex.value]),

      // ---------------- FLOATING BUTTON ----------------
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF006680),
        elevation: 6,
        shape: const CircleBorder(),
        onPressed: () {
          Get.to(UploadPostScreen(isUpdate: false));
        },
        child: const Icon(
          Icons.add_circle_outline,
          size: 28,
          color: Colors.white,
        ),
      ),

      // ---------------- BOTTOM BAR ----------------
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          height: 60,
          elevation: 10,
          shape: const CircularNotchedRectangle(),
          notchMargin: 3,

          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ---------------- LEFT ----------------
                Row(
                  children: [
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        controller.selectedIndex.value = 0;
                      },
                      icon: Icon(
                        Icons.home_filled,
                        color: controller.selectedIndex.value == 0
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        controller.selectedIndex.value = 1;
                      },
                      icon: Icon(
                        Icons.people_alt,
                        color: controller.selectedIndex.value == 1
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                // ---------------- RIGHT ----------------
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.selectedIndex.value = 2;
                      },
                      icon: Icon(
                        Icons.chat,
                        color: controller.selectedIndex.value == 2
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        controller.selectedIndex.value = 3;
                      },
                      icon: Icon(
                        Icons.person_3,
                        color: controller.selectedIndex.value == 3
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
