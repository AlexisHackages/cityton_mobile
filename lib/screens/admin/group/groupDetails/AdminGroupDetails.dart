import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/label.dart';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/screens/admin/group/groupDetails/AdminGroupDetails.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
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

  Map _datas;
  int _groupId;
  String _groupName;

  @override
  void initState() {
    super.initState();

    _datas = widget.arguments;
    _groupId = _datas["groupId"];
    _groupName = _datas["groupName"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _adminGroupDetailsBloc.getGroupInfo(_groupId);

    return FramePage(
        header: Header(
          title: _groupName,
          leadingState: HeaderLeading.DEAD_END,
          iconsAction: _buildHeaderIconsAction(_groupId),
        ),
        sideMenu: null,
        body: FutureBuilder<ApiResponse>(
            future: _adminGroupDetailsBloc.getGroupInfo(_groupId),
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

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
        Widget>[
      Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[700]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Group details",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: space_around_divider),
              Divider(thickness: 1.0),
              SizedBox(height: space_around_divider),
              Label(label: "Name", component: Text(group.name)),
              SizedBox(height: space_between_text),
              Label(label: "Creator", component: Text(group.creator.username)),
              SizedBox(height: space_between_text),
              Label(
                  label: group.hasReachMaxSize
                      ? "Members (group full)"
                      : "Members",
                  component: members),
            ],
          ))
    ]);
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
