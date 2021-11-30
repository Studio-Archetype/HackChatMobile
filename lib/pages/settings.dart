import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../common.dart';
import '../components/sheets/set_text_sheet.dart';

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
        valueListenable: Hive.box(settingsBox).listenable(),
        builder: (context, Box settings, _) {
          String nickname = settings.get('nickname');

          return Container(
            color: const Color(0xff1a1a1a),
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Nickname'),
                  subtitle: Text(nickname),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SetTextSheet(
                          header: 'Set your nickname',
                          initialValue: nickname,
                          onInput: (text) {
                            settings.put('nickname', text);
                          }
                        );
                      },
                    );
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