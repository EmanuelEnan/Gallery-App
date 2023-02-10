import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Image(
              image: AssetImage(
                'assets/01.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 20,
            child: Column(
              children: [
                const Text('Otto International'),
                const Text('Access all the photos in one place'),
                ElevatedButton(
                  onPressed: () {
                    AuthService().signInWithGoogle();
                  },
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
