import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final List<Map<String, String>> pages = [
    {
      'title': 'Connect with Friends and Family',
      'desc':
      'Connecting with Family and Friends provides a sense of belonging and security',
      'button': 'Next',
    },
    {
      'title': 'Make new friends with ease',
      'desc': 'Allowing you to make new Friends is our Number one priority.....',
      'button': 'Next',
    },
    {
      'title': 'Express yourself to the world',
      'desc':
      'Let your voice be heard on the internet through the OFOFO features on the App without restrictions',
      'button': 'Continue',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CarouselSlider.builder(
        itemCount: pages.length,
        itemBuilder: (context, index, realIdx) {
          final page = pages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 32),
                Text(
                  page['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  page['desc']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Handle navigation
                  },
                  child: Text(page['button']!),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                  },
                  child: const Text('Already have an account? Sign in'),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1.0,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }
}
