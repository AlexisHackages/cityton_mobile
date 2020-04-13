import 'package:cityton_mobile/screens/door/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/models/user.dart';

class SideMenu extends StatefulWidget {
  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        _buildDrawHeader(authBloc),
        ListTile(
          title: Text(
            "Home",
            textAlign: TextAlign.center,
          ),
          onTap: () => Navigator.pushNamed(context, '/home'),
        ),
        ListTile(
          title: Text(
            "Threads",
            textAlign: TextAlign.center,
          ),
          onTap: () => Navigator.pushNamed(context, '/threadsList'),
        ),
        ListTile(
          title: Text(
            "Logout",
            textAlign: TextAlign.center,
          ),
          onTap: () => {
            authBloc.logout(),
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (Route<dynamic> route) => false)
          },
        ),
      ]),
    );
  }

  Widget _buildDrawHeader(AuthBloc authBloc) {
    return DrawerHeader(
        child: FutureBuilder<User>(
            future: authBloc.getCurrentUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.all(25.0),
                  child: InkWell(
                    onTap: () => Navigator.popAndPushNamed(context, '/profile'),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data.picture),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(snapshot.data.username),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
