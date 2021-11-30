import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common.dart';
import '../components/global_drawer.dart';
import '../main.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.roomName, required this.nickname}) : super(key: key);
  final String roomName;
  final String nickname;

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    String roomName = widget.roomName;
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const GlobalDrawer(),
      appBar: AppBar(
        title: Text('?${widget.roomName}'),
        actions: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const FaIcon(FontAwesomeIcons.home))
        ],
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, widget) {
          return WebView(
            initialUrl: '$baseUrl?$roomName#${box.get('nickname')}',
            javascriptMode: JavascriptMode.unrestricted,
          );
        },
      ),
    );
  }
}