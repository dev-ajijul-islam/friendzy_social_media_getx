import 'package:friendzy_social_media_getx/modules/chats/controllers/chat_controller.dart';
import 'package:get/get.dart';


class ChatBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatsController());
  }
}