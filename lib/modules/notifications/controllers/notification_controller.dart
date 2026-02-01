import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/data/models/notification_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }

  void getNotifications() async {
    FirebaseServices.firestore
        .collection("users")
        .doc(FirebaseServices.auth.currentUser!.uid)
        .collection("notifications")
        .orderBy("createdAt",descending: true)
        .snapshots()
        .listen(
          (event) => notifications.value = event.docs
              .map((e) => NotificationModel.fromJson(e.data()))
              .toList(),
        );
  }

  Future<void> createNotification({
    required NotificationModel notification,
    required String targetUserId,
  }) async {
    isLoading.value = true;
    try {
      await FirebaseServices.firestore
          .collection("users")
          .doc(targetUserId)
          .collection("notifications")
          .add(notification.toJson());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    } finally {
      isLoading.value = false;
    }
  }
}
