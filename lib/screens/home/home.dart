import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FramePage(
      header: Header(leadingState: HeaderLeading.MENU, title: "Home",),
      sideMenu: MainSideMenu(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return 
    Container(
        child: Column(
      children: <Widget>[Text("Welcome !")],
    ));
  }
}
