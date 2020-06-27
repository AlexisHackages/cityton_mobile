import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/iconText.dart';
import 'package:cityton_mobile/components/label.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/screens/group/myGroup/myGroup.bloc.dart';
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
    return _authBloc.getCurrentUser();
  }

  void _getGroupInfo() {
    _myGroupBloc.getGroupInfo(_currentUser.groupId);
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
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.groupId != 0) {
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
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data.id != null) {
                        _group = snapshot.data;
                        return _buildGroupDetails();
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
    Widget groupdetails;
    if (_group.creator.id == _currentUser.id) {
      groupdetails = _buildGroupDetailsCreator();
    } else {
      groupdetails = _buildGroupDetailsNotCreator();
    }
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[700]),
            child: Column(children: <Widget>[
              Text("My group",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: space_around_divider),
              Divider(thickness: 1.0),
              SizedBox(height: space_around_divider),
              groupdetails
            ])));
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
                      onPressed: () async {
                        await _myGroupBloc
                            .acceptRequest(
                                _group.requestsAdhesion[index].id, _group.id)
                            .then((_) => _getGroupInfo());
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: space_between_text),
        Label(label: "Creator", component: Text(_group.creator.username)),
        SizedBox(height: space_between_text),
        Label(label: "Members", component: members),
        SizedBox(height: space_between_text),
        Label(
            label: _group.hasReachMaxSize
                ? "Requests to join (group full)"
                : "Requests to join",
            component: requests),
        SizedBox(height: space_around_divider),
        Divider(thickness: 1.0),
        SizedBox(height: space_around_divider),
        Text("Delete group ?"),
        RaisedButton(
            child: Text('Delete'),
            onPressed: () {
              _buildDialogDeleteGroup();
            })
      ],
    );
  }

  Widget _buildGroupDetailsNotCreator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Label(
            label: "Name",
            component: IconText.iconClickable(content: Text(_group.name))),
        SizedBox(height: space_between_text),
        Label(label: "Creator", component: Text(_group.creator.username)),
        SizedBox(height: space_between_text),
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
        SizedBox(height: space_around_divider),
        Divider(thickness: 1.0),
        SizedBox(height: space_around_divider),
        Text("Leave group ?"),
        RaisedButton(
            child: Text('Leave'),
            onPressed: () {
              _buildDialogLeaveGroup();
            })
      ],
    );
  }

  _buildDialogDeleteGroup() {
    Get.defaultDialog(
        backgroundColor: Colors.blueGrey[700],
        title: "Delete group",
        content: StatefulBuilder(builder: (context, _setState) {
          return Container(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Are you sure to delete the group ?"),
                        SizedBox(height: space_between_text),
                        Text("All Members and you won't be part of the group"),
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
                                  var response =
                                      await _myGroupBloc.delete(_group.id);

                                  if (response.status == 200) {
                                    _authBloc.refreshCurrentUser();
                                    DisplaySnackbar.createConfirmation(
                                        message: "Group succesfuly deleted");
                                    Get.offAndToNamed('/home');
                                  } else {
                                    DisplaySnackbar.createError(
                                        message: response.value);
                                  }
                                })
                          ],
                        )
                      ])));
        }));
  }

  _buildDialogLeaveGroup() {
    Get.defaultDialog(
        backgroundColor: Colors.blueGrey[700],
        title: "Leave group",
        content: StatefulBuilder(builder: (context, _setState) {
          return Container(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Are you sure to leave the group ?"),
                        SizedBox(height: space_between_text),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Get.back();
                                }),
                            SizedBox(width: space_between_input),
                            RaisedButton(
                                child: Text("I'm sure"),
                                onPressed: () async {
                                  var response =
                                      await _myGroupBloc.leaveGroup(_group.id);

                                  if (response.status == 200) {
                                    _authBloc.refreshCurrentUser();
                                    Get.offAndToNamed('/home');
                                    DisplaySnackbar.createConfirmation(
                                        message: "Group succesfuly left");
                                  } else {
                                    DisplaySnackbar.createError(
                                        message: response.value);
                                  }
                                })
                          ],
                        )
                      ])));
        }));
  }
}
