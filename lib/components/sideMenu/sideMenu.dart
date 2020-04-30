import 'package:cityton_mobile/components/sideMenu/sideMenu.bloc.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:flutter/widgets.dart';

class SideMenu extends StatefulWidget {
  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  AuthBloc authBloc = AuthBloc();
  SideMenuBloc sideMenuBloc = SideMenuBloc();

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
    return Drawer(
        child: FutureBuilder<User>(
            future: authBloc.getCurrentUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              return ListView(children: [
                _buildDrawHeader(snapshot),
                ..._buildDrawBody(snapshot),
              ]);
            }));
  }

  Widget _buildDrawHeader(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return DrawerHeader(
          child: Padding(
        padding: EdgeInsets.all(25.0),
        child: InkWell(
          onTap: () => Navigator.popAndPushNamed(context, '/profile',
              arguments: {"userId": snapshot.data.id}),
          child: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data.picture),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(snapshot.data.username),
              ],
            ),
          ),
        ),
      ));
    } else {
      return CircularProgressIndicator();
    }
  }

  List<Widget> _buildDrawBody(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      User currentUser = snapshot.data;
      Widget admin = currentUser.role != "0" ? _buildAdminMenu() : Container();

      return <Widget>[
        ListTile(
          title: Text(
            "Home",
            textAlign: TextAlign.center,
          ),
          onTap: () => Navigator.pushNamed(context, '/home'),
        ),
        _buildThreadList(currentUser.id),
        admin,
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
      ];
    } else {
      return <Widget>[CircularProgressIndicator()];
    }
  }

  Widget _buildThreadList(int userId) {
    sideMenuBloc.getThreads(userId);

    return ExpansionTile(title: Text("Threads"), children: <Widget>[
      StreamBuilder(
        stream: sideMenuBloc.threads,
        builder: (BuildContext context, AsyncSnapshot<List<Thread>> snapshot) {
          final threads = snapshot.data;
          print("!!!!! THREADLIST !!!!!");
          print(threads);
          print(threads.length);
          print("!!!!! END THREADLIST !!!!!");
          if (threads == null) {
            return Center(child: Text('WAITING...'));
          }

          if (threads.isEmpty) {
            return Center(child: Text('PRINT VOID...'));
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: threads.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text(
                      threads[index].name,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () => {
                          Navigator.pushNamed(context, "/chat",
                              arguments: threads[index].discussionId),
                        });
              });
        },
      )
    ]);
  }

  Widget _buildAdminMenu() {
    return ExpansionTile(
      title: Text("Admin"),
      children: <Widget>[
        ListTile(
          title: Text("Groups"),
          onTap: () {
            Navigator.pushNamed(context, '/admin/group');
          },
        ),
        ListTile(
          title: Text("Users"),
          onTap: () {
            Navigator.pushNamed(context, '/admin/user');
          },
        ),
        ListTile(
          title: Text("Challenges"),
          onTap: () {
            Navigator.pushNamed(context, '/admin/challenge');
          },
        ),
      ],
    );
  }
}
