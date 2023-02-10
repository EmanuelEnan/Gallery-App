import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'models/bookmarks.dart';

import 'services/auth_service.dart';

const String boxName = 'store';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB2FkpKyaDTkIKWcecQQ6sLyThspDW50cM",
        appId: "1:199015945834:web:cc4c94ae3882617c859c13",
        messagingSenderId: "199015945834",
        projectId: "gallery-app-cb706",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
      home: AuthService().handleAuthState(),
    );
  }
}
