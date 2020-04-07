import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
  final bool deadEnd;
  final String title;
  final List<Widget> actions;

  const Header({Key key, this.deadEnd = false, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar (
      leading: _buildLeading(context),
      title: Text(title),
      actions: actions
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (deadEnd) {
      return
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        );
    } else {
      return
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer()
        );
    }
  }

  @override
  Size get preferredSize => new Size.fromHeight(50.0);
}