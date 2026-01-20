import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/auth/controllers/sign_up_controller.dart';
import 'package:friendzy_social_media_getx/modules/auth/views/forgot_password_screen.dart';
import 'package:friendzy_social_media_getx/modules/auth/widgets/google_sign_in_widget.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'Enter your credentials',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withAlpha(600),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: controller.nameController,
                decoration: _inputDecoration(
                  "Enter your Full name",
                  colorScheme,
                ),
                validator: (value) =>
                    value!.isNotEmpty ? null : "Enter full name",
              ),

              TextFormField(
                controller: controller.emailController,
                decoration: _inputDecoration("Enter your email", colorScheme),
                validator: (value) =>
                    GetUtils.isEmail(value!) ? null : "Enter a valid email",
              ),

              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration:
                      _inputDecoration(
                        "Enter your password",
                        colorScheme,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                  validator: (value) =>
                      value!.length < 6 ? "Password must be 6+ chars" : null,
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: colorScheme.secondary),
                  ),
                ),
              ),

              _buildActionButton(
                "Sign Up",
                colorScheme,
                controller.signUp,
                controller,
              ),
              const SizedBox(height: 10),
              GoogleSignInWidget(),

              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Do not have an Account? ",
                    style: TextStyle(color: colorScheme.onSurface),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.signInScreen);
                          },
                        text: "Sign In",
                        style: TextStyle(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, ColorScheme color) =>
      InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: color.onSurface.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );

  Widget _buildActionButton(
    String label,
    ColorScheme color,
    VoidCallback tap,
    SignUpController controller,
  ) => SizedBox(
    width: double.infinity,
    height: 55,
    child: Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.secondary,
          foregroundColor: color.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: controller.isEmailSignInProgress.value ? null : tap,
        child: controller.isEmailSignInProgress.value
            ? ButtonLoading()
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ),
  );
}
