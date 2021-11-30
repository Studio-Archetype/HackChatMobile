import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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