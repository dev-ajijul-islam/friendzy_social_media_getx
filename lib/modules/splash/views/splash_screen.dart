import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/auth/views/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () => FirebaseServices.auth.currentUser != null
          ? Get.offAllNamed(AppRoutes.mainLayout)
          : Get.offAllNamed(AppRoutes.signInScreen),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(top: 150, left: 80, child: _buildCircle(25)),
          Positioned(top: 100, right: 60, child: _buildCircle(45)),
          Positioned(bottom: 200, right: 50, child: _buildCircle(30)),
          Positioned(bottom: 120, left: 70, child: _buildCircle(35)),

          Center(
            child: Text(
              'Friendzy',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: ColorScheme.of(context).primary,
                letterSpacing: -1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF006680),
        shape: BoxShape.circle,
      ),
    );
  }
}
