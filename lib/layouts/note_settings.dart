import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class NoteSettings extends StatefulWidget {
  const NoteSettings({super.key});

  @override
  State<NoteSettings> createState() => _NoteSettingsState();
}

class _NoteSettingsState extends State<NoteSettings> {
  late bool isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Used AppBar just for the back icon
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quicksand"
                  ),
                ),
                CupertinoSwitch(
                  value: isDark,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    setState(() {
                      isDark = !isDark;
                    });
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}