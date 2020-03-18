import "package:flutter/material.dart";

class FramePage extends StatelessWidget {

  final Widget headerNav;
  final Widget sideMenu;
  final Widget body;

  // const FramePage({Key key, this.headerNav, this.sideMenu, this.body}) : super(key: key);
  const FramePage({Key key, this.headerNav, this.sideMenu, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: headerNav,
      // drawer: sideMenu,
      body: body
    );
  }
}