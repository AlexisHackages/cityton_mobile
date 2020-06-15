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

  Future<User> _currentUser;
  Map _datas;
  int _groupId;
  String _groupName = "...";
  String _creatorName = "...";

  @override
  void initState() {
    super.initState();

    _datas = widget.arguments;
    _groupId = _datas["groupId"];

    _currentUser = _initCurrentUser();
  }

  Future<User> _initCurrentUser() async {
    return await _authBloc.getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    _myGroupBloc.closeChallengeStream();
  }

  @override
  Widget build(BuildContext context) {
    _myGroupBloc.getGroupInfo(_groupId);

    return FramePage(
        header: Header(
          title: "My Group",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: StreamBuilder<Group>(
            stream: _myGroupBloc.groupDetails,
            builder: (BuildContext context, AsyncSnapshot<Group> snapshot) {
              if (snapshot.hasData && snapshot.data.id != null) {
                Group group = snapshot.data;
                _groupName = group.name;
                return Column(
                  children: <Widget>[_buildGroupDetails(group)],
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildGroupDetails(Group group) {
    return FutureBuilder<User>(
        future: _currentUser,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data.id != null) {
            _creatorName = group.creator.username;
            User currentUser = snapshot.data;
            if (group.creator.id == currentUser.id) {
              return _buildGroupDetailsCreator(group);
            } else {
              return _buildGroupDetailsNotCreator(group);
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildGroupDetailsCreator(Group group) {
    Widget members = group.members.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: group.members.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  group.members[index].user.username,
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _myGroupBloc.deleteMembership(
                          group.members[index].id, group.id);
                    }),
              );
            })
        : Text("No members except the creator");
    Widget requests = group.requestsAdhesion.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: group.requestsAdhesion.length,
            itemBuilder: (BuildContext context, int index) {
              Widget accept = group.hasReachMaxSize
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        _myGroupBloc.acceptRequest(
                            group.requestsAdhesion[index].id, group.id);
                      });
              return ListTile(
                  title: Text(
                    group.requestsAdhesion[index].user.username,
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
                                group.requestsAdhesion[index].id, group.id);
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
                content: Text(_groupName),
                trailing: IconButtonCustom(
                    onAction: () {
                      Get.toNamed('/myGroup/edit', arguments: {
                        "groupId": _groupId,
                        "groupName": _groupName
                      });
                    },
                    icon: Icons.mode_edit))),
        Label(label: "Creator", component: Text(_creatorName)),
        Label(label: "Members", component: members),
        Label(
            label: group.hasReachMaxSize
                ? "Requests to join (group full)"
                : "Requests to join",
            component: requests),
        Text("Delete group ?"),
        RaisedButton(
            child: Text('Delete'),
            onPressed: () {
              Get.dialog(Container(
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    Text('''
                        Are you sure to delete the group ?
                        All Members and you won't be part of the group'''),
                    RaisedButton(
                        child: Text("I'm sure"),
                        onPressed: () async {
                          var response = await _myGroupBloc.delete(group.id);

                          if (response.status == 200) {
                            DisplaySnackbar.createConfirmation(
                                message: "Group succesfuly deleted");
                            Get.off(Home());
                          } else {
                            DisplaySnackbar.createConfirmation(
                                message: response.value);
                          }
                        })
                  ])));
            })
      ],
    );
  }

  Widget _buildGroupDetailsNotCreator(Group group) {
    return Column(
      children: <Widget>[
        Label(
            label: "Name", component: IconText.iconClickable(content: Text(_groupName))),
        Label(label: "Creator", component: Text(_creatorName)),
        Label(
            label: "Members",
            component: ListView.builder(
                shrinkWrap: true,
                itemCount: group.members.length,
                itemBuilder: (BuildContext context, int index) {
                  return group.members.length > 0
                      ? ListTile(
                          title: Text(
                            group.members[index].user.username,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Text("No memebers except the creator");
                })),
      ],
    );
  }
}
