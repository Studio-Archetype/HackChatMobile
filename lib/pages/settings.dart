import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, widget) {
          return Container(
            color: const Color(0xff1a1a1a),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Nickname',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                TextFormField(
                  initialValue: box.get('nickname'),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (text) {
                    box.put('nickname', text);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}