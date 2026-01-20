import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/auth/controllers/google_sign_in_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';

class GoogleSignInWidget extends StatelessWidget {
  const GoogleSignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleSignInController controller =
        Get.find<GoogleSignInController>();
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        icon: Icon(Icons.g_mobiledata, size: 30, color: color.onSurface),
        label: controller.inProcess.value
            ? ButtonLoading()
            : Text(
                "Sign in with Google",
                style: TextStyle(color: color.onSurface),
              ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.onSurface.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: controller.inProcess.value ? null : controller.signIn,
      ),
    );
  }
}
