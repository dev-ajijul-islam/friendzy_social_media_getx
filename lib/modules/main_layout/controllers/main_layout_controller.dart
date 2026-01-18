import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/modules/chats/views/chats_screen.dart';
import 'package:friendzy_social_media_getx/modules/home/views/home_screen.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/views/upload_post_screen.dart';
import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final List<Widget> screens = [
    const HomeScreen(),
    const Center(child: Text("Explore")),
    const UploadPostScreen(),
    const ChatsScreen(),
    const Center(child: Text("Profile")),
  ];
}