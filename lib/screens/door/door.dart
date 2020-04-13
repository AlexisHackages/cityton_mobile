import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/constants/door.constants.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/screens/door/widgets/signup.widgets.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/screens/door/widgets/login.widgets.dart';

class Door extends StatefulWidget {
  final ShowBody showBody;

  Door({@required this.showBody});

  @override
  DoorState createState() => DoorState();
}

class DoorState extends State<Door> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ShowBody.LOGIN == widget.showBody) {
      return FramePage(
        header: Header(
          title: "Door",
          leadingState: HeaderLeading.NO_LEADING,
        ),
        sideMenu: SideMenu(),
        body: Login(),
      );
    } else if (ShowBody.SIGNUP == widget.showBody) {
      return FramePage(
        header: Header(
          title: "Door",
          leadingState: HeaderLeading.NO_LEADING,
        ),
        sideMenu: SideMenu(),
        body: Signup(),
      );
    }

    return FramePage(
      header: Header(
        title: "Door",
        leadingState: HeaderLeading.NO_LEADING,
      ),
      sideMenu: SideMenu(),
      body: Login(),
    );
  }
}
