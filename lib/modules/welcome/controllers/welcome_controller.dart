import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final PageController pageController = PageController();
  final List<Map<String, String>> pages = [
    {
      'title': 'Connect with Friends and Family',
      'desc':
      'Connecting with Family and Friends provides a sense of belonging and security',
    },
    {
      'title': 'Make new friends with ease',
      'desc':
      'Allowing you to make new Friends is our Number one priority.....',
    },
    {
      'title': 'Express yourself to the world',
      'desc':
      'Let your voice be heard on the internet through the FRIENDZY features on the App without restrictions',
    },
  ];

  RxInt currentIndex = 0.obs;
  RxBool isLastPage = false.obs;

  void changePage(int index) {
    currentIndex.value = index;
    isLastPage.value = index == pages.length - 1;
  }
}