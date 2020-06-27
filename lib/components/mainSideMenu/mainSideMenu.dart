import 'package:cityton_mobile/components/mainSideMenu/mainsideMenu.bloc.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MainSideMenu extends StatefulWidget {
  @override
  MainSideMenuState createState() => MainSideMenuState();
}

class MainSideMenuState extends State<MainSideMenu> {
  AuthBloc _authBloc = AuthBloc();
  MainSideMenuBloc _mainSideMenuBloc = MainSideMenuBloc();

  User _currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future<User> _initCurrentUser() {
    return _authBloc.getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    _mainSideMenuBloc.closeThreads();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder<User>(
            future: _initCurrentUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                _currentUser = snapshot.data;
                return ListView(children: [
                  _buildDrawHeader(),
                  ..._buildDrawBody(),
                ]);
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildDrawHeader() {
    return DrawerHeader(
        child: Padding(
      padding: EdgeInsets.all(25.0),
      child: InkWell(
        onTap: () => Get.offAndToNamed('/profile',
            arguments: {"userId": _currentUser.id}),
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(_currentUser.picture),
              ),
              SizedBox(
                width: 25,
              ),
              Text(_currentUser.username),
            ],
          ),
        ),
      ),
    ));
  }

  List<Widget> _buildDrawBody() {
    Widget admin = Role.values[_currentUser.role] == Role.Admin
        ? _buildAdminMenu()
        : Container();

    return <Widget>[
      ListTile(
        title: Text(
          "Home",
          textAlign: TextAlign.center,
        ),
        onTap: () => Get.toNamed('/home'),
      ),
      _buildThreadList(),
      _buildGroup(),
      admin,
      ListTile(
        title: Text(
          "Logout",
          textAlign: TextAlign.center,
        ),
        onTap: () => {
          _authBloc.logout(),
          Get.offNamedUntil('/door', (Route<dynamic> route) => false)
        },
      ),
    ];
  }

  Widget _buildThreadList() {
    _mainSideMenuBloc.getThreads(_currentUser.id);

    return ExpansionTile(title: Text("Threads"), children: <Widget>[
      StreamBuilder(
        stream: _mainSideMenuBloc.threads,
        builder: (BuildContext context, AsyncSnapshot<List<Thread>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            final threads = snapshot.data;
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
                            Get.toNamed("/chat",
                                arguments: {"thread": threads[index]}),
                          });
                });
          } else {
            return CircularProgressIndicator();
          }
        },
      )
    ]);
  }

  Widget _buildGroup() {
    Widget createAGroup = _currentUser.groupId == 0 &&
            Role.values[_currentUser.role] == Role.Member
        ? ListTile(
            title: Text("Create a group"),
            onTap: () {
              Get.toNamed('/group/create');
            },
          )
        : Container();

    Widget myGroup = 
            Role.values[_currentUser.role] == Role.Member &&  _currentUser.groupId > 0
        ? ListTile(
            title: Text("My group"),
            onTap: () {
              Get.toNamed('/myGroup',
                  arguments: {"groupId": _currentUser.groupId});
            },
          )
        : Container();

    return ExpansionTile(
      title: Text("Group"),
      children: <Widget>[
        ListTile(
          title: Text("Groups"),
          onTap: () {
            Get.toNamed('/groups');
          },
        ),
        createAGroup,
        myGroup,
      ],
    );
  }

  Widget _buildAdminMenu() {
    return ExpansionTile(
      title: Text("Admin"),
      children: <Widget>[
        ListTile(
          title: Text("Groups"),
          onTap: () {
            Get.toNamed('/admin/group');
          },
        ),
        ListTile(
          title: Text("Users"),
          onTap: () {
            Get.toNamed('/admin/user');
          },
        ),
        ListTile(
          title: Text("Challenges"),
          onTap: () {
            Get.toNamed('/admin/challenge');
          },
        ),
      ],
    );
  }
}
