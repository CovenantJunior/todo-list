import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
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
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Authenticate Google user
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // If user is not authenticated, prompt for authorization
        await _googleSignIn.signInSilently();
        final googleUser = await _googleSignIn.signIn();
        final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
        if (googleUser == null) {
          // Show backup error message
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
        } else {
          var currentUser = context.read<TodoListDatabase>().user;
          int id = currentUser.first.id;
          context.read<TodoListDatabase>().setGoogleUser(id, googleUser.email, googleUser.id, googleUser.photoUrl, googleUser.displayName);
          BackupService().backupUserData(context, backup: true);
        }
      }
    } catch (e) {
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