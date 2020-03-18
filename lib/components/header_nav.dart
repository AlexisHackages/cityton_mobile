import 'package:flutter/material.dart';

class HeaderNav extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  // final List<Widget> actions;

  // const HeaderNav({Key key, this.title, this.actions}) : super(key: key);
  const HeaderNav({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar (
      title: Text(title),
      // actions: actions
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(60.0);
}