import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/modules/home/views/home_screen.dart';
import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final List<Widget> screens = [
    const HomeScreen(),
    const Center(child: Text("Explore")),
    const Center(child: Text("Add Post")),
    const Center(child: Text("Messages")),
    const Center(child: Text("Profile")),
  ];
}