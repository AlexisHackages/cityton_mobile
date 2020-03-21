import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/auth_bloc.dart';
import 'package:cityton_mobile/blocs/side_menu_bloc.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key key}) : super(key: key);

  final AuthBloc authBloc = new AuthBloc();
  final SideMenuBloc sideMenuBloc = new SideMenuBloc();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          child: Text("DRAWER HEADER"),
        ),
        ExpansionTile(
          title: Text(
            "Messages",
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            ListTile(
              title: Text(
                "Periodo 1",
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              title: Text(
                "Periodo 2",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        ListTile(
          title: Text(
            "Logout",
            textAlign: TextAlign.center,
          ),
          onTap: () => {
            sideMenuBloc.getThreads(),
            authBloc.logout(),
            Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false)
          },
        ),
        ListTile(
          title: Text(
            "Test",
            textAlign: TextAlign.center,
          ),
          onTap: () => {
            sideMenuBloc.getThreads()
          },
        ),
      ]),
    );
  }
}
