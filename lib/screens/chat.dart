import 'package:cityton_mobile/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/side_menu_bloc.dart';
import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/models/thread.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final int args = ModalRoute.of(context).settings.arguments;

    print("OOOOO");
    print(args);
    print("KKKKK");

    return FramePage(
        header: Header(title: "Chat"),
        sideMenu: SideMenu(),
        body: Center(
          child: Text("CHAT"),
        ));
  }
}
