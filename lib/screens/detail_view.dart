import 'package:flutter/material.dart';
import 'package:gallery_app/widgets/image_widget.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: imageWidget1(),
          ),
          SafeArea(
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
            ),
          ),
        ],
      ),
    );
  }
}
