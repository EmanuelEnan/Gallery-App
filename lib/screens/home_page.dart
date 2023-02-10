import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_app/models/bookmarks.dart';
import 'package:gallery_app/screens/detail_view.dart';
import 'package:gallery_app/screens/save_page.dart';
import 'package:gallery_app/services/auth_service.dart';
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

  // ImageService imageService = ImageService();

  final List<String> posts = [];
  int page = 1;
  final int maxLength = 1000;
  late ScrollController scrollController;

  bool isLoading = false;
  bool hasMore = true;

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
      // final created = e['createdAt'];

      posts.add(imageUrl);
      // posts.add(created);
    }

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
            child: const Image(
              image: AssetImage(
                'assets/01.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          // Positioned(
          //   top: height * .3,
          //   child: Container(
          //     height: height * .7,
          //     width: width,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(16),
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   right: 20,
          //   top: 25,
          //   child: IconButton(
          //     onPressed: () {
          //       AuthService().signOut();
          //     },
          //     icon: const Icon(Icons.logout_rounded),
          //   ),
          // ),
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
                          children: const [
                            Text(
                              'Otto International',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Check all the latest photos',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
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
                          child: const Text(
                            'BOOKMARKS',
                            style: TextStyle(color: Colors.black54),
                          ),
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
                                        // createDate: posts[index],
                                      ),
                                    ),
                                  );
                                },
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

                                            myBox.add(
                                              Bookmarks(photoUrl: photoUrl),
                                            );

                                            final snackBar = SnackBar(
                                              backgroundColor:
                                                  Colors.black.withOpacity(.3),
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              content: const Center(
                                                  child: Text('photo saved!')),
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
                // FutureBuilder<List<ImageModel>>(
                //   future: imageService.getApi(),
                //   builder: (context, snapshot) {
                //     if (!snapshot.hasData) {
                //       return const Center(
                //         child: CircularProgressIndicator(
                //           color: Colors.white54,
                //         ),
                //       );
                //     } else if (snapshot.hasData) {
                //       return Column(
                //         children: [
                //           Expanded(
                //             child: Padding(
                //               padding: const EdgeInsets.all(6.0),
                //               child: GridView.custom(
                //                 gridDelegate: SliverWovenGridDelegate.count(
                //                   crossAxisCount: 2,
                //                   // mainAxisSpacing: 2,
                //                   // crossAxisSpacing: 2,
                //                   pattern: [
                //                     const WovenGridTile(1),
                //                     const WovenGridTile(
                //                       5 / 7,
                //                       crossAxisRatio: 0.9,
                //                       alignment: AlignmentDirectional.centerEnd,
                //                     ),
                //                   ],
                //                 ),
                //                 childrenDelegate: SliverChildBuilderDelegate(
                //                   childCount: 30,
                //                   (context, index) {
                //                     return GestureDetector(
                //                       onTap: () {
                //                         Navigator.of(context).push(
                //                           MaterialPageRoute(
                //                             builder: (_) => DetailView(
                //                               url: snapshot
                //                                   .data![index].urls!.small!,
                //                               createDate: snapshot
                //                                   .data![index].createdAt!,
                //                             ),
                //                           ),
                //                         );
                //                       },
                //                       child: CachedNetworkImage(
                //                         imageUrl:
                //                             snapshot.data![index].urls!.small!,
                //                         imageBuilder:
                //                             (context, imageProvider) => Stack(
                //                           children: [
                //                             Container(
                //                               decoration: BoxDecoration(
                //                                 image: DecorationImage(
                //                                   image: imageProvider,
                //                                   fit: BoxFit.cover,
                //                                 ),
                //                               ),
                //                             ),
                //                             Positioned(
                //                               right: 10,
                //                               top: 10,
                //                               child: IconButton(
                //                                 onPressed: () {},
                //                                 icon: Icon(
                //                                   Icons.bookmark,
                //                                   color: Colors.black
                //                                       .withOpacity(.4),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         placeholder: (context, url) =>
                //                             const Center(
                //                           child: CircularProgressIndicator(),
                //                         ),
                //                         errorWidget: (context, url, error) =>
                //                             const Center(
                //                           child: Icon(Icons.error),
                //                         ),
                //                       ),

                //                       // ClipRRect(
                //                       //   borderRadius: BorderRadius.circular(14),
                //                       //   child: Image.network(
                //                       //     snapshot.data![index].urls!.small!,
                //                       //     height: 300,
                //                       //     width: 300,
                //                       //   ),
                //                       // ),
                //                     );
                //                   },
                //                 ),
                //               ),
                //             ),
                //             //   itemCount: snapshot.data!.length,
                //             //   itemBuilder: (context, index) {
                //             //     return Column(
                //             //       children: [
                //             //         // Text(
                //             //         //   snapshot.data![index].id!,
                //             //         // ),
                //             //         Image.network(
                //             //           snapshot.data![index].urls!.small!,
                //             //           height: 300,
                //             //           width: 300,
                //             //         ),
                //             //       ],
                //             //     );
                //             //   },
                //             // ),
                //           ),
                //         ],
                //       );
                //     } else {
                //       return const Text('error');
                //     }
                //   },
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
