import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullImageViewController extends GetxController {
  late PageController pageController;
  RxInt initialIndex = 0.obs;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = initialIndex.value;
    pageController = PageController(initialPage: initialIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}