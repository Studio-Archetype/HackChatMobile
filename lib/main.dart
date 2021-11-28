import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const baseUrl = 'https://chat.bytecode.ninja';
const settingsBox = 'settings';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox(settingsBox);

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const MyApp());
}

class DrawerItem extends StatefulWidget {
  const DrawerItem({Key? key, required this.text, this.icon, required this.onTap}) : super(key: key);
  final String text;
  final IconData? icon;
  final Function() onTap;

  @override
  _DrawerItemState createState() => _DrawerItemState();
}
class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    TextStyle _whiteText = const TextStyle(
      color: Colors.white,
    );

    return ListTile(
      title: Text(widget.text, style: _whiteText),
      leading: widget.icon != null ? FaIcon(widget.icon!, color: Colors.grey) : null,
      onTap: widget.onTap,
    );
  }
}

class GlobalDrawer extends StatelessWidget {
  const GlobalDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.zero,
        color: const Color(0xff1a1a1a),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/hackchatbanner.png')),
                ),
                child: Column(
                  children: [
                    const Text('HackChat',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    Text(Uri.parse(baseUrl).host,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              DrawerItem(
                text: 'Create / Join a room',
                icon: FontAwesomeIcons.plus,
                onTap: () {
                  openChat(context);
                }
              ),
              DrawerItem(
                text: 'Settings',
                icon: FontAwesomeIcons.cog,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Default Rooms',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              DrawerItem(
                text: '?lounge',
                onTap: () {
                  _openRoomPage(context, 'lounge');
                },
              ),
              DrawerItem(
                text: '?meta',
                onTap: () {
                  _openRoomPage(context, 'meta');
                },
              ),
              DrawerItem(
                text: '?studio',
                onTap: () {
                  _openRoomPage(context, 'studio');
                },
              ),
              DrawerItem(
                text: '?minecraft',
                onTap: () {
                  _openRoomPage(context, 'minecraft');
                },
              ),
              DrawerItem(
                text: '?programming',
                onTap: () {
                  _openRoomPage(context, 'programming');
                },
              ),
              DrawerItem(
                text: '?resourcepacks',
                onTap: () {
                  _openRoomPage(context, 'resourcepacks');
                },
              ),
              const Divider(),
              DrawerItem(
                text: 'Join Our Discord',
                icon: FontAwesomeIcons.discord,
                onTap: () {
                  launchUrl('https://discord.com/invite/ApqWqYp');
                },
              ),
              DrawerItem(
                text: 'Check out Our Website',
                icon: FontAwesomeIcons.globe,
                onTap: () {
                  launchUrl('https://studioarchetype.net');
                },
              ),
            ],
          ),
      ),
    );
  }
}

class SetNicknameSheet extends StatefulWidget {
  const SetNicknameSheet({Key? key, required this.onInput}) : super(key: key);
  final void Function(String) onInput;

  @override
  _SetNicknameSheetState createState() => _SetNicknameSheetState();
}
class _SetNicknameSheetState extends State<SetNicknameSheet> {
  String _textFieldText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Set a nickname'),
          TextField(
            onChanged: (text) {
              setState(() {
                _textFieldText = text;
              });
            },
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Set'),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onInput(_textFieldText);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OpenChatSheet extends StatefulWidget {
  const OpenChatSheet({Key? key}) : super(key: key);

  @override
  _OpenChatSheetState createState() => _OpenChatSheetState();
}
class _OpenChatSheetState extends State<OpenChatSheet> {
  String _textFieldText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Join or create a room'),
          TextField(
            onChanged: (text) {
              setState(() {
                _textFieldText = text;
              });
            },
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Join'),
                  onPressed: () {
                    Navigator.pop(context);
                    _openRoomPage(context, _textFieldText);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

void _openRoomPage(BuildContext context, String roomName) {
  Box box = Hive.box(settingsBox);

  if (box.containsKey('nickname')) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(
      roomName: roomName,
      nickname: box.get('nickname'),
    )));
  } else {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SetNicknameSheet(onInput: (text) {
          box.put('nickname', text);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(
            roomName: roomName,
            nickname: text
          )));
        });
      },
    );
  }
}
void openChat(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return const OpenChatSheet();
    },
  );
}
void launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Unable to launch URL: $url';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackChat',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MyHomePage(title: Uri.parse(baseUrl).host),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final Widget hackchatSvg = SvgPicture.asset('assets/hackchat.svg');
  final Widget hackchatSplashBottomSvg = SvgPicture.asset('assets/hackchatsplashbottom.svg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const GlobalDrawer(),
      appBar: AppBar(
        title: Text(Uri
        .parse(baseUrl)
        .host),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 1.5,
            colors: [
              Color(0xff262626),
              Color(0xff1a1a1a),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 150,
                child: hackchatSvg,
              ),
            ),
            const Expanded(child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Welcome, this is a privately hosted instance of hack.chat, operated by STUDIO ARCHETYPE.\nThis system is used internally for temporary support and self destructing chat, as we primarily use Discord.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 100,
                child: hackchatSplashBottomSvg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

    return Scaffold(
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
          onPressed: () => Scaffold.of(context).openDrawer(),
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
