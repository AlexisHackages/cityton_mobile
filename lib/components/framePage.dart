import "package:flutter/material.dart";

class FramePage extends StatelessWidget {

  final Widget header;
  final Widget sideMenu;
  final Widget body;

  const FramePage({Key key, @required this.header, @required this.sideMenu, @required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: header,
      drawer: sideMenu,
      body: body
    );
  }
}