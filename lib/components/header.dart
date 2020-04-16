import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final HeaderLeading leadingState;
  final String title;
  final List<Widget> actions;

  const Header(
      {Key key,
      @required this.leadingState,
      @required this.title,
      this.actions})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    
    if (HeaderLeading.NO_LEADING == leadingState) {
      return AppBar(title: Text(title), actions: actions);
    } else if (HeaderLeading.MENU == leadingState) {
      return AppBar(
          leading: _buildMenu(context), title: Text(title), actions: actions);
    } else {
      // headerLeading.DEAD_END
      return AppBar(
          leading: _buildBack(context), title: Text(title), actions: actions);
    }
  }

  Widget _buildMenu(BuildContext context) {
    
    return IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer());
  }

  Widget _buildBack(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }
}
