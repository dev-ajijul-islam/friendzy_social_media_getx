import 'package:flutter/material.dart';

class GoogleSignInWidget extends StatelessWidget {
  const GoogleSignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        icon: Icon(Icons.g_mobiledata, size: 30, color: color.onSurface),
        label: Text(
          "Sign in with Google",
          style: TextStyle(color: color.onSurface),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.onSurface.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
