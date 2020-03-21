import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final List<Widget> actions;

  const Header({Key key, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar (
      leading: 
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer()
          ),
      title: Text(title),
      actions: actions
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(50.0);
}