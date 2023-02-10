import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.url});

  final String url;
  // final String createDate;

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
          Center(
            child: Image.network(
              url,
              // height: 300,
              // width: 300,
            ),
          ),
        ],
      ),
    );
  }
}
