// ignore_for_file: use_build_context_synchronously

import 'dart:io' as fa;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Backup {
  Isar? isar; 

  DateTime date = DateTime.now();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['SERVER_CLIENT'],
    scopes: [drive.DriveApi.driveFileScope],
  );

  String generateTimestampId() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  Future<void> backup(BuildContext context, {required backup}) async {
    try {
      // Get directory
    final dir = await getApplicationDocumentsDirectory();
    // Initialize Isar
    isar = Isar.getInstance();
    // Create file
    fa.File backupFile = fa.File("${dir.path}/.minimalist");
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
        return backup;
      } else {
        // Initialize Drive API
        final driveApi = drive.DriveApi(client!);

        // Search for the file in Google Drive
        drive.FileList fileList = await driveApi.files.list(
          q: "name='.minimalist'",
          spaces: 'drive',
          $fields: 'files(id)',
        );

        if (fileList.files!.isNotEmpty) {
          // File exists, update it
          final fileId = fileList.files![0].id;
          // Update the file using its ID
          final upload = driveApi.files.update(
            drive.File(name: '.minimalist'),
            fileId!,
            uploadMedia: drive.Media(backupFile.openRead(), backupFile.lengthSync()),
          );
          // Execute upload
          await upload.onError((error, stackTrace) {
            // Show backup error message
            ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                duration: const Duration(seconds: 1),
                content: const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red),
                    SizedBox(width: 10),
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
          });
        } else {
          // Create file metadata
          final upload = driveApi.files.create(
            drive.File(
              name: '.minimalist',
            ),
            uploadMedia: drive.Media(backupFile.openRead(), backupFile.lengthSync()),
          );
          // Execute upload
          await upload.onError((error, stackTrace) {
            // Show backup error message
            ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                duration: const Duration(seconds: 1),
                content: const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red),
                    SizedBox(width: 10),
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
          });
        }
      }
    } else {
        final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
        // Initialize Drive API
        final driveApi = drive.DriveApi(client!);

        // Search for the file in Google Drive
        drive.FileList fileList = await driveApi.files.list(
          q: "name='.minimalist'",
          spaces: 'drive',
          $fields: 'files(id)',
        );

        if (fileList.files!.isNotEmpty) {
          // File exists, update it
          final fileId = fileList.files![0].id;
          // Update the file using its ID
          final upload = driveApi.files.update(
            drive.File(name: '.minimalist'),
            fileId!,
            uploadMedia: drive.Media(backupFile.openRead(), backupFile.lengthSync()),
          );
          // Execute upload
          await upload.onError((error, stackTrace) {
            // Show backup error message
            ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                duration: const Duration(seconds: 1),
                content: const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red),
                    SizedBox(width: 10),
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
          });
        } else {
          // Create file metadata
          final upload = driveApi.files.create(
            drive.File(
              name: '.minimalist',
            ),
            uploadMedia: drive.Media(backupFile.openRead(), backupFile.lengthSync()),
          );
          // Execute upload
          await upload.onError((error, stackTrace) {
            // Show backup error message
            ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                duration: const Duration(seconds: 1),
                content: const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red),
                    SizedBox(width: 10),
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
          });
        }
    }

    // Call backup function
    backup();
    } catch (e) {
      backup();
      
      // Show backup error message
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        duration: const Duration(seconds: 1),
        content: const Row(children: [
          Icon(Icons.error_outline_rounded, color: Colors.red),
          SizedBox(width: 10),
          Text('Check your internet connection',
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
        ]),
      ));
    }
  }
}
