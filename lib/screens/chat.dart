import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/chat_bloc.dart';
import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header_nav.dart';
import 'package:cityton_mobile/components/side_menu.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {

  ChatBloc chatBloc = new ChatBloc();

  @override
  Widget build(BuildContext context) {

    return FramePage (
      headerNav: HeaderNav(title: "Chat"),
      sideMenu: SideMenu(),
      body: Center(
        child: Text('Hello World'),
      )
    );
  }
}
