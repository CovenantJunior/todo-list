// ignore_for_file: use_build_context_synchronously

import 'dart:io' as fa;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class Backup {
  Isar? isar; 

  DateTime date = DateTime.now();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: "702532065815-r76gi0bsj1ikchjhlmmphmdvramgdfrr.apps.googleusercontent.com",
    scopes: [drive.DriveApi.driveFileScope],
  );

  Future<void> backup(BuildContext context, {required backup}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7)
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed,
        content: const Text('Backing up...',
          style: TextStyle(
            fontFamily: "Quicksand", fontWeight: FontWeight.w500
          )
        ),
      ),
    );

    // Get directory
    final dir = await getApplicationDocumentsDirectory();
    // Initialize Isar
    isar = Isar.getInstance();
    // Create file
    fa.File backupFile = fa.File("${dir.path}/minimalist.isar");
    // Check if file exists and delete if it does
    if (await backupFile.exists()) {
      await backupFile.delete();
    }
    // Copy Isar DB to file
    await isar?.copyToFile(backupFile.path);

    // Authenticate Google user
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // If user is not authenticated, prompt for authorization
      await _googleSignIn.signInSilently();
      final googleUser = await _googleSignIn.signIn();
      final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
      if (googleUser == null) {
        // Show backup completed message
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          duration: const Duration(seconds: 1),
          content: const Row(children: [
            Icon(Icons.error_outline_rounded),
            Text('Something went wrong',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
          ]),
        ));
        return backup;
      } else {
        // Initialize Drive API
        final driveApi = drive.DriveApi(client!);

        // Create file metadata
        final upload = driveApi.files.create(
          drive.File(
            name: 'minimalist.isar',
          ),
          uploadMedia: drive.Media(backupFile.openRead(), backupFile.lengthSync()),
        );

        // Execute upload
        await upload.onError((error, stackTrace) {
          // Show backup completed message
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              duration: const Duration(seconds: 1),
              content: const Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded
                  ),
                  Text('Something went wrong',
                  style: TextStyle(
                      fontFamily: "Quicksand", fontWeight: FontWeight.w500)
                    ),
                ]
              ),
            )
          );
          return backup;
        }).whenComplete(() {
          // Show backup completed message
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              duration: const Duration(seconds: 1),
              content: const Text('Backup completed',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500)
                  ),
            )
          );
        }
        );
      }
    } else {
        final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
        // Initialize Drive API
        final driveApi = drive.DriveApi(client!);

        // Create file metadata
        final upload = driveApi.files.create(
          drive.File(
            name: 'minimalist.isar',
          ),
          uploadMedia: drive.Media(backupFile.openRead(), backupFile.lengthSync()),
        );

        // Execute upload
        await upload.onError((error, stackTrace) {
          // Show backup completed message
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              duration: const Duration(seconds: 1),
              content: const Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded
                  ),
                  Text('Something went wrong',
                  style: TextStyle(
                      fontFamily: "Quicksand", fontWeight: FontWeight.w500)
                    ),
                ]
              ),
            )
          );
          return backup;
        }).whenComplete(() {
          // Show backup completed message
          ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              duration: const Duration(seconds: 1),
              content: const Text('Backup completed',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500)
                  ),
            )
          );
        }
        );
    }


    // Call backup function
    backup();
  }
}
