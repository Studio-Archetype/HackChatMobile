import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common.dart';
import '../components/global_drawer.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Widget hackchatSvg = SvgPicture.asset('assets/hackchat.svg');
  final Widget hackchatSplashBottomSvg = SvgPicture.asset('assets/hackchatsplashbottom.svg');

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const GlobalDrawer(),
      appBar: AppBar(
        title: Text(Uri
            .parse(baseUrl)
            .host),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
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