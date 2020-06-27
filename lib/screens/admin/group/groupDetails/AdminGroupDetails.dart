import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/label.dart';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/models/userMinimal.dart';
import 'package:cityton_mobile/screens/admin/group/groupDetails/AdminGroupDetails.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:get/get.dart';

class AdminGroupDetails extends StatefulWidget {
  final Map arguments;

  AdminGroupDetails({@required this.arguments});

  @override
  AdminGroupDetailsState createState() => AdminGroupDetailsState();
}

class AdminGroupDetailsState extends State<AdminGroupDetails> {
  AdminGroupDetailsBloc _adminGroupDetailsBloc = AdminGroupDetailsBloc();

  int _groupId;
  String _groupName;
  UserMinimal _selectedUser;
  int _selectedUserId;
  Group _groupInfo;
  List<UserMinimal> _staffMembers;

  @override
  void initState() {
    super.initState();

    Map datas = widget.arguments;
    _groupId = datas["groupId"];
    _groupName = datas["groupName"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  refreshGroupInfo() {
    _adminGroupDetailsBloc.getGroupInfo(_groupId);
  }

  openDialog(BuildContext context) {
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
                      ..._staffMembers
                          .map(
                            (user) => RadioListTile<int>(
                              title: Text(user.username),
                              value: user.id,
                              groupValue: _selectedUserId,
                              onChanged: (int userId) {
                                _setState(() {
                                  _selectedUser = _staffMembers.firstWhere(
                                      (element) => element.id == userId);
                                  _selectedUserId = _selectedUser.id;
                                });
                              },
                            ),
                          )
                          .toList()
                    ],
                  )));
        }),
        onConfirm: () async {
          var response = await _adminGroupDetailsBloc.attributeSupervisor(
              _groupId, _selectedUserId);
          if (response.status == 200) {
            refreshGroupInfo();
            DisplaySnackbar.createConfirmation(
                message: "Supervisor succesfuly attributed");
            Get.back();
          } else {
            DisplaySnackbar.createError(message: response.value);
          }
        },
        onCancel: () {
          Get.back();
        });
  }

  @override
  Widget build(BuildContext context) {
    refreshGroupInfo();

    return FramePage(
        header: Header(
          title: _groupName,
          leadingState: HeaderLeading.DEAD_END,
          resultOnBack: true,
          iconsAction: _buildHeaderIconsAction(_groupId),
        ),
        sideMenu: null,
        body: FutureBuilder<ApiResponse>(
            future: _adminGroupDetailsBloc.getAllStaffMember(),
            builder: (BuildContext context,
                AsyncSnapshot<ApiResponse> snapshotFutureBuilder) {
              return StreamBuilder(
                  stream: _adminGroupDetailsBloc.groupInfo,
                  builder: (BuildContext context,
                      AsyncSnapshot<Group> snapshotStream) {
                    if (snapshotFutureBuilder.hasData &&
                        snapshotFutureBuilder.data != null &&
                        snapshotStream.hasData &&
                        snapshotStream.data != null) {
                      if (snapshotFutureBuilder.data.status == 200) {
                        _groupInfo = snapshotStream.data;
                        _staffMembers = UserMinimalList.fromJson(
                                snapshotFutureBuilder.data.value)
                            .users;
                        return _buildGroupDetails(context);
                      } else {
                        DisplaySnackbar.createError(
                            message: snapshotFutureBuilder.data.value);
                        return Container();
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            }));
  }

  Widget _buildGroupDetails(BuildContext context) {
    _selectedUser = _groupInfo.supervisor;
    _selectedUserId = _selectedUser?.id;

    Widget members = _groupInfo.members.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _groupInfo.members.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  _groupInfo.members[index].user.username,
                  textAlign: TextAlign.center,
                ),
              );
            })
        : Text("No members except the creator",
            style: TextStyle(color: Colors.red));

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey[700]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Group details",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: space_around_divider),
                      Divider(thickness: 1.0),
                      SizedBox(height: space_around_divider),
                      Label(label: "Name", component: Text(_groupInfo.name)),
                      SizedBox(height: space_between_text),
                      Label(
                          label: "Creator",
                          component: Text(_groupInfo.creator.username)),
                      SizedBox(height: space_between_text),
                      Label(
                          label: _groupInfo.hasReachMaxSize
                              ? "Members (group full)"
                              : "Members",
                          component: Column(children: <Widget>[
                            !_groupInfo.hasReachMinSize
                                ? Text("minimal size requirement unfilled",
                                    style: TextStyle(color: Colors.red))
                                : Container(),
                            members
                          ])),
                      SizedBox(height: space_around_divider),
                      Divider(thickness: 1.0),
                      SizedBox(height: space_around_divider),
                      Label(
                          label: "Supervisor",
                          component: _groupInfo.supervisor == null
                              ? Column(children: <Widget>[
                                  Text("No supervisor attributed",
                                      style: TextStyle(color: Colors.red)),
                                  RaisedButton(
                                      child: Text("Select one"),
                                      onPressed: () {
                                        openDialog(context);
                                      })
                                ])
                              : Column(children: <Widget>[
                                  Text(_groupInfo.supervisor.username),
                                  RaisedButton(
                                      child: Text("Change"),
                                      onPressed: () {
                                        openDialog(context);
                                      })
                                ])),
                    ],
                  ))
            ]));
  }

  List<IconButton> _buildHeaderIconsAction(int groupId) {
    return <IconButton>[
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            var response = await _adminGroupDetailsBloc.delete(groupId);

            if (response.status == 200) {
              DisplaySnackbar.createConfirmation(
                  message: "Group succesfuly deleted");
                  Get.back(result: true);
            } else {
              DisplaySnackbar.createError(message: response.value);
            }
          })
    ];
  }
}
