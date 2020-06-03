import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/label.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/screens/group/allGroups/details/groupDetails.bloc.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class GroupDetails extends StatefulWidget {
  final Map arguments;

  GroupDetails({@required this.arguments});

  @override
  GroupDetailsState createState() => GroupDetailsState();
}

class GroupDetailsState extends State<GroupDetails> {
  GroupDetailsBloc groupDetailsBloc = GroupDetailsBloc();
  AuthBloc authBloc = AuthBloc();

  Map datas;
  int groupId;
  String groupName;

  Future<User> _currentUser;

  @override
  void initState() {
    super.initState();

    datas = widget.arguments;
    groupId = datas["groupId"];
    groupName = datas["groupName"];
    _currentUser = _initCurrentUser();
  }

  Future<User> _initCurrentUser() async {
    return await authBloc.getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    groupDetailsBloc.getGroupInfo(groupId);

    return FramePage(
        header: Header(
          title: "Infos " + groupName,
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: StreamBuilder<Group>(
            stream: groupDetailsBloc.groupDetails,
            builder: (BuildContext context, AsyncSnapshot<Group> snapshot) {
              if (snapshot.hasData && snapshot.data.id != null) {
                Group group = snapshot.data;
                return FutureBuilder<User>(
                    future: _currentUser,
                    builder:
                        (BuildContext context, AsyncSnapshot<User> snapshot) {
                      if (snapshot.hasData && snapshot.data.id != null) {
                        User user = snapshot.data;
                        return _buildGroupDetails(group, user);
                      } else {
                        return CircularProgressIndicator();
                      }
                    });
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildGroupDetails(Group group, User currentUser) {
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
              );
            })
        : Text("No members except the creator");

    List<Widget> request = Role.values[currentUser.role] == Role.Member &&
            currentUser.groupId < 1
        ? <Widget>[
            Text(
              "Join group ?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
                child: Text('Ask to join'),
                onPressed: () async {
                  var response = await groupDetailsBloc.createRequest(group.id);

                  if (response.status == 200) {
                    DisplaySnackbar.createConfirmation(message: "Request sent");
                  } else {
                    DisplaySnackbar.createConfirmation(message: response.value);
                  }
                })
          ]
        : List<Widget>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[700]),
          child: Column(
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Group details",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: space_around_divider),
                      Divider(thickness: 1.0),
                      SizedBox(height: space_around_divider),
                      Label(label: "Name", component: Text(group.name)),
                      SizedBox(height: space_between_text),
                      Label(
                          label: "Creator",
                          component: Text(group.creator.username)),
                      SizedBox(height: space_between_text),
                      Label(
                          label: group.hasReachMaxSize
                              ? "Members (group full)"
                              : "Members",
                          component: members)
                    ]),
                SizedBox(height: space_around_divider),
                Divider(thickness: 1.0),
                SizedBox(height: space_around_divider),
                ...request
              ]),
        )
      ],
    );
  }
}
