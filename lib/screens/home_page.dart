import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_app/models/bookmarks.dart';
import 'package:gallery_app/screens/detail_view.dart';
import 'package:gallery_app/screens/save_page.dart';
import 'package:gallery_app/services/auth_service.dart';
import 'package:gallery_app/widgets/image_widget.dart';
import 'package:gallery_app/widgets/text_widget.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../tokens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Tokens tokens = Tokens();
  Box<Bookmarks> myBox = Hive.box<Bookmarks>(boxName);

  final List<String> posts = [];
  int page = 1;
  final int maxLength = 1000;
  late ScrollController scrollController;

  bool isLoading = false;
  bool hasMore = true;

  // connecting API
  getApi() async {
    setState(() {
      isLoading = true;
    });
    String url =
        '${tokens.baseUrl}?per_page=20&page=$page&order_by=latest&client_id=${tokens.clientId}';

    final response = await http.get(
      Uri.parse(url),
    );

    List data = jsonDecode(response.body);

    for (final e in data) {
      final imageUrl = e['urls']['small'];

      posts.add(imageUrl);
    }

    // implementing infinte scrolling
    setState(() {
      isLoading = false;
      page = page + 1;
      hasMore = posts.length < maxLength;
    });
  }

  @override
  void initState() {
    super.initState();
    getApi();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * .95 &&
          !isLoading) {
        if (hasMore) {
          getApi();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 30,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hi, ${FirebaseAuth.instance.currentUser!.displayName}, welcome to',
                        ),
                        IconButton(
                          onPressed: () {
                            AuthService().signOut();
                          },
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget1('Otto International'),
                            textWidget2('Check all the latest photos'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SavePage(),
                              ),
                            );
                          },
                          child: textWidget2('BOOKMARKS'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GridView.custom(
                          // physics: const BouncingScrollPhysics(),
                          controller: scrollController,
                          gridDelegate: SliverWovenGridDelegate.count(
                            crossAxisCount: 2,
                            // mainAxisSpacing: 2,
                            // crossAxisSpacing: 2,
                            pattern: [
                              const WovenGridTile(1),
                              const WovenGridTile(
                                5 / 7,
                                crossAxisRatio: 0.9,
                                alignment: AlignmentDirectional.centerEnd,
                              ),
                            ],
                          ),
                          childrenDelegate: SliverChildBuilderDelegate(
                            childCount: posts.length + (hasMore ? 1 : 0),
                            (context, index) {
                              if (index == posts.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DetailView(
                                        url: posts[index],
                                      ),
                                    ),
                                  );
                                },
                                // local cache mechanism
                                child: CachedNetworkImage(
                                  imageUrl: posts[index],
                                  imageBuilder: (context, imageProvider) =>
                                      Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: IconButton(
                                          onPressed: () {
                                            var photoUrl = posts[index];

                                            // local bookmarks
                                            myBox.add(
                                              Bookmarks(photoUrl: photoUrl),
                                            );

                                            final snackBar = SnackBar(
                                              backgroundColor:
                                                  Colors.black.withOpacity(.3),
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              content: const Center(
                                                child: Text('photo saved!'),
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          icon: Icon(
                                            Icons.bookmark,
                                            color: Colors.black.withOpacity(.4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
