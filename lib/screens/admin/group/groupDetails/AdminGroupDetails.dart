import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/label.dart';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/screens/admin/group/groupDetails/AdminGroupDetails.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class AdminGroupDetails extends StatefulWidget {
  final Map arguments;

  AdminGroupDetails({@required this.arguments});

  @override
  AdminGroupDetailsState createState() => AdminGroupDetailsState();
}

class AdminGroupDetailsState extends State<AdminGroupDetails> {
  AdminGroupDetailsBloc _adminGroupDetailsBloc = AdminGroupDetailsBloc();

  Map datas;
  int groupId;
  String groupName;

  @override
  void initState() {
    super.initState();

    datas = widget.arguments;
    groupId = datas["groupId"];
    groupName = datas["groupName"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _adminGroupDetailsBloc.getGroupInfo(groupId);

    return FramePage(
        header: Header(
          title: "Infos " + groupName,
          leadingState: HeaderLeading.DEAD_END,
          iconsAction: _buildHeaderIconsAction(groupId),
        ),
        sideMenu: null,
        body: FutureBuilder<ApiResponse>(
            future: _adminGroupDetailsBloc.getGroupInfo(groupId),
            builder:
                (BuildContext context, AsyncSnapshot<ApiResponse> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                if (data.status == 200) {
                  Group group = Group.fromJson(data.value);
                  return _buildGroupDetails(group);
                } else {
                  DisplaySnackbar.createError(message: data.value);
                  return Container();
                }
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildGroupDetails(Group group) {
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

    return Column(
      children: <Widget>[
        Label(label: "Name", component: Text(group.name)),
        Label(label: "Creator", component: Text(group.creator.username)),
        Label(
            label: group.hasReachMaxSize ? "Members (group full)" : "Members",
            component: members),
      ],
    );
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
            } else {
              DisplaySnackbar.createError(message: response.value);
            }
          })
    ];
  }
}
