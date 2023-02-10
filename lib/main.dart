import 'package:flutter/material.dart';
import 'package:gallery_app/screens/starting_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/bookmarks.dart';
import 'screens/home_page.dart';

const String boxName = 'store';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(BookmarksAdapter());
  await Hive.openBox<Bookmarks>(boxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartingPage(),
    );
  }
}
