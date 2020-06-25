import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/iconText.dart';
import 'package:cityton_mobile/components/label.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/screens/group/myGroup/myGroup.bloc.dart';
import 'package:cityton_mobile/screens/home/home.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:get/get.dart';

class MyGroup extends StatefulWidget {
  final Map arguments;

  MyGroup({@required this.arguments});

  @override
  MyGroupState createState() => MyGroupState();
}

class MyGroupState extends State<MyGroup> {
  MyGroupBloc _myGroupBloc = MyGroupBloc();
  AuthBloc _authBloc = AuthBloc();

  User _currentUser;
  Group _group;

  @override
  void initState() {
    super.initState();
  }

  Future<User> _initCurrentUser() async {
    return await _authBloc.getCurrentUser();
  }

  _getGroupInfo() {
    _myGroupBloc.getGroupInfo(_currentUser.groupId);
  }

  void _refreshCurrentUser() async {
    var res = await _myGroupBloc.refreshCurrentUser();
    if (res.status != 200) {
      DisplaySnackbar.createError(message: res.value);
      Get.toNamed('/door');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _myGroupBloc.closeChallengeStream();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _initCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _currentUser = snapshot.data;
            _getGroupInfo();
            return FramePage(
                header: Header(
                  title: "My Group",
                  leadingState: HeaderLeading.DEAD_END,
                ),
                sideMenu: null,
                body: StreamBuilder<Group>(
                    stream: _myGroupBloc.groupDetails,
                    builder:
                        (BuildContext context, AsyncSnapshot<Group> snapshot) {
                      // print(snapshot.hasData);
                      // if (snapshot.hasData) {
                      //   print(snapshot.data != null);
                      //   if (snapshot.data != null) {
                      //     print(snapshot.data);
                      //     print(snapshot.data.id != null);
                      //     if (snapshot.data.id != null) {
                      //       print(snapshot.data);
                      //       print(snapshot.data.id);
                      //     }
                      //   }
                      // }
                      print("ARRIVED");
                      print(snapshot.hasData);
                      print(snapshot.hasData && snapshot.data != null);
                      print(snapshot.hasData && snapshot.data != null && snapshot.data.id != null);
                      if (snapshot.hasData && snapshot.data != null && snapshot.data.id != null) {
                        print("++++++++++");
                        _group = snapshot.data;
                        print(_group.id);
                        print("++++++++++");
                        return Column(
                          children: <Widget>[_buildGroupDetails()],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildGroupDetails() {
    if (_group.creator.id == _currentUser.id) {
      return _buildGroupDetailsCreator();
    } else {
      return _buildGroupDetailsNotCreator();
    }
  }

  Widget _buildGroupDetailsCreator() {
    Widget members = _group.members.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _group.members.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  _group.members[index].user.username,
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _myGroupBloc.deleteMembership(
                          _group.members[index].id, _group.id);
                    }),
              );
            })
        : Text("No members except the creator");
    Widget requests = _group.requestsAdhesion.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _group.requestsAdhesion.length,
            itemBuilder: (BuildContext context, int index) {
              Widget accept = _group.hasReachMaxSize
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        _myGroupBloc.acceptRequest(
                            _group.requestsAdhesion[index].id, _group.id);
                      });
              return ListTile(
                  title: Text(
                    _group.requestsAdhesion[index].user.username,
                    textAlign: TextAlign.center,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      accept,
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _myGroupBloc.deleteRequest(
                                _group.requestsAdhesion[index].id, _group.id);
                          })
                    ],
                  ));
            })
        : Text("No Request");

    return Column(
      children: <Widget>[
        Label(
            label: "Name",
            component: IconText.iconClickable(
                content: Text(_group.name),
                trailing: IconButtonCustom(
                    onAction: () {
                      Get.toNamed('/myGroup/edit', arguments: {
                        "groupId": _group.id,
                        "groupName": _group.name
                      }).then((value) => value ? _getGroupInfo() : null);
                    },
                    icon: Icons.mode_edit))),
        Label(label: "Creator", component: Text(_group.creator.username)),
        Label(label: "Members", component: members),
        Label(
            label: _group.hasReachMaxSize
                ? "Requests to join (group full)"
                : "Requests to join",
            component: requests),
        Text("Delete group ?"),
        RaisedButton(
            child: Text('Delete'),
            onPressed: () {
              Get.defaultDialog(
                  backgroundColor: Colors.blueGrey[700],
                  content: StatefulBuilder(builder: (context, _setState) {
                    return Container(
                        height: MediaQuery.of(context).size.height * (50 / 100),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Are you sure to delete the group ?"),
                                  SizedBox(height: space_between_text),
                                  Text(
                                      "All Members and you won't be part of the group"),
                                  SizedBox(height: space_between_text),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RaisedButton(
                                          child: Text("Back"),
                                          onPressed: () {
                                            Get.back();
                                          }),
                                      SizedBox(width: space_between_input),
                                      RaisedButton(
                                          child: Text("I'm sure"),
                                          onPressed: () async {
                                            var response = await _myGroupBloc
                                                .delete(_group.id);

                                            if (response.status == 200) {
                                              _refreshCurrentUser();
                                              DisplaySnackbar.createConfirmation(
                                                  message:
                                                      "Group succesfuly deleted");
                                              Get.off(Home());
                                            } else {
                                              DisplaySnackbar
                                                  .createConfirmation(
                                                      message: response.value);
                                            }
                                          })
                                    ],
                                  )
                                ])));
                  }));
            })
      ],
    );
  }

  Widget _buildGroupDetailsNotCreator() {
    return Column(
      children: <Widget>[
        Label(
            label: "Name",
            component: IconText.iconClickable(content: Text(_group.name))),
        Label(label: "Creator", component: Text(_group.creator.username)),
        Label(
            label: "Members",
            component: ListView.builder(
                shrinkWrap: true,
                itemCount: _group.members.length,
                itemBuilder: (BuildContext context, int index) {
                  return _group.members.length > 0
                      ? ListTile(
                          title: Text(
                            _group.members[index].user.username,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Text("No memebers except the creator");
                })),
      ],
    );
  }
}
