import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home_page.dart';
import '../screens/starting_page.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  /// Returns the authentication state stream builder.
  ///
  /// The stream listens to the authentication state changes
  /// of FirebaseAuth instance.

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return const HomePage();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('something went wrong'),
          );
        } else {
          return const StartingPage();
        }
      },
    );
  }

  /// Signs in the user using their Google account.
  ///
  /// Signs in the user using the GoogleSignIn instance,
  /// and retrieves the GoogleSignInAccount object.

  Future signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseException catch (e) {
      if (e.code == 'user-disabled') {
        // FirebaseAuth.instance.currentUser!.reload();
        print('user disabled');
      } else {
        print(
          e.toString(),
        );
      }
    }
  }

  /// Signs out the user.

  Future signOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
