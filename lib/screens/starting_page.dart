import 'package:flutter/material.dart';
import 'package:gallery_app/widgets/text_widget.dart';

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
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget1('Otto International'),
                textWidget2('Access all the photos in one place'),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 206, 225),
                  ),
                  onPressed: () {
                    AuthService().signInWithGoogle();
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
