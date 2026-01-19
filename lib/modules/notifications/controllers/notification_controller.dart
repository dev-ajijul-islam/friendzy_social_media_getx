import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Mock data grouped by date
  final notificationsToday = [
    {'name': 'Patrick', 'action': 'Followed you', 'time': 'Just Now', 'image': 'https://i.pravatar.cc/150?u=1'},
    {'name': 'Chris', 'action': 'Followed you', 'time': '2mins ago', 'image': 'https://i.pravatar.cc/150?u=2'},
    {'name': 'Segun', 'action': 'Liked your photo', 'time': '15mins ago', 'image': 'https://i.pravatar.cc/150?u=3'},
    {'name': 'Chris', 'action': 'commented on your post', 'time': '1hour ago', 'image': 'https://i.pravatar.cc/150?u=4'},
  ].obs;

  final notificationsPast = [
    {'name': 'Patrick', 'action': 'Followed you', 'time': '11:20am', 'image': 'https://i.pravatar.cc/150?u=5'},
    {'name': 'Chris', 'action': 'Followed you', 'time': '10:00am', 'image': 'https://i.pravatar.cc/150?u=6'},
    {'name': 'Segun', 'action': 'Liked your photo', 'time': '09:00am', 'image': 'https://i.pravatar.cc/150?u=7'},
    {'name': 'Chris', 'action': 'commented on your post', 'time': '07:00am', 'image': 'https://i.pravatar.cc/150?u=8'},
  ].obs;

  void clearAll() {
    notificationsToday.clear();
    notificationsPast.clear();
  }
}