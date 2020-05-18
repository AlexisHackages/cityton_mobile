import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/label.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/screens/group/allGroups/details/groupDetails.bloc.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GroupDetails extends StatefulWidget {
  final Map arguments;

  GroupDetails({@required this.arguments});

  @override
  GroupDetailsState createState() => GroupDetailsState();
}

class GroupDetailsState extends State<GroupDetails> {
  GroupDetailsBloc groupDetailsBloc = GroupDetailsBloc();
  AuthBloc authBloc = AuthBloc();

  Future<User> _currentUser;
  Map datas;
  int groupId;
  String groupName;

  final GlobalKey<FormBuilderState> _addFormKey = GlobalKey<FormBuilderState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController creatorController = TextEditingController();

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
                return _buildGroupDetails(group);
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildGroupDetails(Group group) {
    return Column(
      children: <Widget>[
        Label(label: "Name", component: Text(group.name)),
        Label(label: "Creator", component: Text(group.creator.username)),
        Label(
            label: group.hasReachMaxSize ? "Members (group full)" : "Members",
            component: ListView.builder(
                shrinkWrap: true,
                itemCount: group.members.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      group.members[index].user.username,
                      textAlign: TextAlign.center,
                    ),
                  );
                })),
        Text("Join group ?"),
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
      ],
    );
  }
}
