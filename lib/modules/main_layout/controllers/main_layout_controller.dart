import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/modules/chats/views/chats_screen.dart';
import 'package:friendzy_social_media_getx/modules/friends/views/friends_screen.dart';
import 'package:friendzy_social_media_getx/modules/home/views/home_screen.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/views/my_profile_screen.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/views/upload_post_screen.dart';
import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final List<Widget> screens = [
    const HomeScreen(),
    const FriendsScreen(),
    const UploadPostScreen(),
    const ChatsScreen(),
    const MyProfileScreen()
  ];
}