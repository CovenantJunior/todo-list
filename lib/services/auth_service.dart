// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:todo_list/services/backup_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );

  // Sign in with Google and Backup
  Future<void> signInWithGoogle(BuildContext context) async {
    // print('Signing in with Google...');
    try {
      // Authenticate Google user
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        // Show error message if sign-in fails
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          duration: const Duration(seconds: 5),
          content: const Row(children: [
            Icon(Icons.error_outline_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Sign in error',
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

      // print('Authenticating...');
      UserCredential result = await _auth.signInWithCredential(credential);
      User? authUser = result.user;

      if (authUser != null) {
        // print('Authenticated as ${authUser.displayName}');
        var currentUser = context.read<TodoListDatabase>().user;
        int id = currentUser.first.id;
        context.read<TodoListDatabase>().setGoogleUser(id, googleUser.email, googleUser.id, googleUser.photoUrl, googleUser.displayName);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          duration: const Duration(seconds: 5),
          content: const Row(children: [
            Icon(Icons.check_circle_outline_rounded, color: Colors.green),
            SizedBox(width: 10),
            Text('Signed in',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
          ]),
        ));
      }
    } catch (e) {
      // Show error message if sign-in fails
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        duration: const Duration(seconds: 5),
        content: const Row(children: [
          Icon(Icons.error_outline_rounded, color: Colors.red),
          SizedBox(width: 10),
          Text('Sign in failed',
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
        ]),
      ));
      // print('Error signing in with Google: $e');
    }
  }

  // Sign in with Google and Backup
  Future<void> signInWithGoogleAndBackup(BuildContext context, todoLists, preferences, {required backup}) async {
    // print('Signing in with Google...');
    try {
      // Authenticate Google user
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        // Show error message if sign-in fails
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            duration: const Duration(seconds: 5),
            content: const Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red),
                SizedBox(width: 10),
                Text('Sign in error',
                style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500
                )
               ),
              ]
            ),
          )
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // print('Authenticating...');
      UserCredential result = await _auth.signInWithCredential(credential);
      User? authUser = result.user;

      if (authUser != null) {
        // print('Authenticated as ${authUser.displayName}');
        var currentUser = context.read<TodoListDatabase>().user;
        int id = currentUser.first.id;
        context.read<TodoListDatabase>().setGoogleUser(id, googleUser.email, googleUser.id, googleUser.photoUrl, googleUser.displayName);
        List user = context.read<TodoListDatabase>().user;
        // Delay for 3 seconds before backing up user data
        Future.delayed(const Duration(seconds: 3), () {
          BackupService().backupUserData(context, user.first, todoLists, preferences, backup: backup);
        });
      }
    } catch (e) {
      backup();
        // Show error message if sign-in fails
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          duration: const Duration(seconds: 5),
          content: const Row(children: [
            Icon(Icons.error_outline_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Sign in failed',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
          ]),
        ));
      // print('Error signing in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut(context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      // print('Signed out');
      // context.read<TodoListDatabase>().clearUser();
      Provider.of<TodoListDatabase>(context, listen: false).clearUser();
      Navigator.pop(context);
      // Show success message if sign-out works
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        duration: const Duration(seconds: 5),
        content: const Row(children: [
          Icon(Icons.check_circle_outline_rounded, color: Colors.green),
          SizedBox(width: 10),
          Text('Sign-out successful',
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
        ]),
      ));
    } catch (e) {
      // print('Error signing out: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}