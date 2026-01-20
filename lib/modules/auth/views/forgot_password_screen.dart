import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_in_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignInController>();
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
      body: Form(

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Let's help recover your account",
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildField(
                    "Email",
                    controller.forgotEmailController,
                    "Enter your email",
                    colorScheme,
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.resetPassword,
                  child: const Text(
                    "Send Email",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctr,
    String hint,
    ColorScheme color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        TextFormField(
          controller: ctr,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: color.onSurface.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => value!.isEmpty ? "Field required" : null,
        ),
      ],
    );
  }
}
