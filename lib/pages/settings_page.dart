import 'package:flutter/material.dart';
import 'package:studi_kasus_flutter_habit_tracker/main.dart';
import 'package:studi_kasus_flutter_habit_tracker/utils/shared_pref.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _usernameController;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _isDarkMode = MyApp.of(context).widget.isDarkMode;
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await SharedPref.getUsername() ?? '';
    _usernameController.text = username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                SharedPref.setUsername(value);
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                MyApp.of(context).changeTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
