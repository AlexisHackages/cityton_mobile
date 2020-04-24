import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final HeaderLeading leadingState;
  final String title;
  final List<IconButton> iconsAction;

  const Header(
      {Key key,
      @required this.leadingState,
      @required this.title,
      this.iconsAction})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    // print("!!!!! HEADER !!!!!");
    // print(iconsAction);
    // print(iconsAction == null);
    // print(iconsAction.length);
    // print("!!!!! END HEADER !!!!!");

    if (HeaderLeading.NO_LEADING == leadingState) {
      return AppBar(title: Text(title), actions: _buildActions());
    } else if (HeaderLeading.MENU == leadingState) {
      return AppBar(
          leading: _buildMenu(context),
          title: Text(title),
          actions: _buildActions());
    } else {
      // headerLeading.DEAD_END
      return AppBar(
        leading: _buildBack(context),
        title: Text(title),
        actions: _buildActions(),
      );
    }
  }

  List<Widget> _buildActions() {
    if (iconsAction != null) {
      List<Widget> widgets = List<Widget>();

      iconsAction.forEach((IconButton iconsButton) => widgets.add(iconsButton));

      return widgets;
    } else {
      return List<Widget>();
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
