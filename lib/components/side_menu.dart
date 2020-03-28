import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/auth_bloc.dart';

class SideMenu extends StatefulWidget {
  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {

  final AuthBloc authBloc = new AuthBloc();

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          child: Text("DRAWER HEADER"),
        ),
        ListTile(
          title: Text(
            "Threads",
            textAlign: TextAlign.center,
          ),
          onTap: () => {
            Navigator.pushNamed(context, '/threadsList')
          },
        ),
        ListTile(
          title: Text(
            "Logout",
            textAlign: TextAlign.center,
          ),
          onTap: () => {
            authBloc.logout(),
            Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false)
          },
        ),
      ]),
    );
  }
}
