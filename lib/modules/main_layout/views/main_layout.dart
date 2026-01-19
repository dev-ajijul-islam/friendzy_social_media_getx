import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  MainLayout({super.key});

  final controller = Get.find<MainLayoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
        ),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              controller.selectedIndex.value = index;
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: ColorScheme.of(context).secondary,
            unselectedItemColor: Colors.black87,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 28,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
