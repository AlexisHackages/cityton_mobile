import 'package:cityton_mobile/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/side_menu_bloc.dart';
import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {

  SideMenuBloc chatBloc = SideMenuBloc();
  AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {

    
    print("READ");
    print(authBloc.getToken());
    print("END READ");

    return FramePage (
      header: Header(title: "Chat"),
      sideMenu: SideMenu(),
      body: Center(
        child: Text('Hello World'),
      )
    );
  }
}
