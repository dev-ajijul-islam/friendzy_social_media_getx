import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/auth/views/forgot_password_screen.dart';
import 'package:friendzy_social_media_getx/modules/auth/widgets/google_sign_in_widget.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';
import '../controllers/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your credentials',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withAlpha(600),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: controller.emailController,
                  decoration: _inputDecoration("Enter your email", colorScheme),
                  validator: (value) =>
                      GetUtils.isEmail(value!) ? null : "Enter a valid email",
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 24),
                _buildActionButton(
                  "Login",
                  colorScheme,
                  controller.login,
                  controller,
                ),

                const SizedBox(height: 20),
                GoogleSignInWidget(),
                const SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Do not have an Account? ",
                      style: TextStyle(color: colorScheme.onSurface),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(AppRoutes.signUpScreen);
                            },
                          text: "Sign up",
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
    SignInController controller,
  ) => SizedBox(
    width: double.infinity,
    height: 55,
    child: Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.primary,
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
