import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';
import '../pages/settings.dart';
import '../common.dart';
import 'drawer_item.dart';

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
                openRoomPage(context, 'lounge');
              },
            ),
            DrawerItem(
              text: '?meta',
              onTap: () {
                openRoomPage(context, 'meta');
              },
            ),
            DrawerItem(
              text: '?studio',
              onTap: () {
                openRoomPage(context, 'studio');
              },
            ),
            DrawerItem(
              text: '?minecraft',
              onTap: () {
                openRoomPage(context, 'minecraft');
              },
            ),
            DrawerItem(
              text: '?programming',
              onTap: () {
                openRoomPage(context, 'programming');
              },
            ),
            DrawerItem(
              text: '?resourcepacks',
              onTap: () {
                openRoomPage(context, 'resourcepacks');
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