import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.chat_bubble_outline, color: Colors.black),
    );
  }
}
