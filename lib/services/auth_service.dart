// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:todo_list/services/backup_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['SERVER_CLIENT'],
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context, {required backup}) async {
    try {
      // Authenticate Google user
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        // Show error message if sign-in fails
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          duration: const Duration(seconds: 1),
          content: const Row(children: [
            Icon(Icons.error_outline_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Something went wrong',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
          ]),
        ));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        print('Authenticating...');
        var currentUser = context.read<TodoListDatabase>().user;
        int id = currentUser.first.id;
        context.read<TodoListDatabase>().setGoogleUser(id, googleUser.email, googleUser.id, googleUser.photoUrl, googleUser.displayName);
        BackupService().backupUserData(context, backup: true);
        print('Backing up...');
      }
    } catch (e) {
      backup();
      print('Error signing in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}