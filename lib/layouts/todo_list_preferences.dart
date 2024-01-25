import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class TodoListPreferences extends StatefulWidget {
  const TodoListPreferences({super.key});

  @override
  State<TodoListPreferences> createState() => _TodoListPreferencesState();
}

class _TodoListPreferencesState extends State<TodoListPreferences> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preferences",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSection('Appearance', [
                _buildPreferenceItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  switchValue: isDark,
                  onSwitchChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    setState(() {
                      isDark = !isDark;
                    });
                  },
                ),
              ]),
              const Divider(height: 20),
              _buildSection('Notifications', [
                _buildPreferenceItem(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notification',
                  switchValue: false, // Replace with your notification logic
                  onSwitchChanged: (value) {},
                ),
              ]),
              const Divider(height: 20),
              _buildSection('Data Management', [
                _buildPreferenceItem(
                  icon: Icons.add_to_drive,
                  label: 'Backup to Drive',
                  switchValue: false, // Replace with your backup logic
                  onSwitchChanged: (value) {},
                ),
                const Divider(height: 20),
                _buildPreferenceItem(
                  icon: Icons.sync_rounded,
                  label: 'Auto Sync',
                  switchValue: false, // Replace with your auto sync logic
                  onSwitchChanged: (value) {},
                ),
              ]),
              const Divider(height: 20),
              _buildSection('Task Management', [
                _buildPreferenceItem(
                  icon: Icons.auto_delete_outlined,
                  label: 'Auto Delete Completed Task',
                  switchValue: false, // Replace with your auto delete logic
                  onSwitchChanged: (value) {},
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String label,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Quicksand",
        ),
      ),
      trailing: CupertinoSwitch(
        value: switchValue,
        onChanged: onSwitchChanged,
      ),
    );
  }
}
