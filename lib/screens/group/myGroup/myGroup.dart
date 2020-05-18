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
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class MyGroup extends StatefulWidget {
  final Map arguments;

  MyGroup({@required this.arguments});

  @override
  MyGroupState createState() => MyGroupState();
}

class MyGroupState extends State<MyGroup> {
  MyGroupBloc myGroupBloc = MyGroupBloc();
  AuthBloc authBloc = AuthBloc();

  Future<User> _currentUser;
  Map datas;
  int _groupId;
  String _groupName = "...";
  String _creatorName = "...";

  @override
  void initState() {
    super.initState();

    datas = widget.arguments;
    _groupId = datas["groupId"];

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
    myGroupBloc.getGroupInfo(_groupId);

    return FramePage(
        header: Header(
          title: "My Group",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: StreamBuilder<Group>(
            stream: myGroupBloc.groupDetails,
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
    return Column(
      children: <Widget>[
        Label(
            label: "Name",
            component: IconText.iconClickable(
                text: _groupName,
                trailing: IconButtonCustom(
                    onAction: () {
                      Get.dialog(_buildEditName(group));
                    },
                    icon: Icons.mode_edit))),
        Label(label: "Creator", component: Text(_creatorName)),
        Label(
            label: "Members",
            component: ListView.builder(
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
                          myGroupBloc.deleteMembership(
                              group.members[index].id, group.id);
                        }),
                  );
                })),
        Label(
            label: group.hasReachMaxSize
                ? "Requests to join (group full)"
                : "Requests to join",
            component: ListView.builder(
                shrinkWrap: true,
                itemCount: group.requestsAdhesion.length,
                itemBuilder: (BuildContext context, int index) {
                  Widget accept = group.hasReachMaxSize
                      ? Container()
                      : IconButton(
                          icon: Icon(Icons.done),
                          onPressed: () {
                            myGroupBloc.acceptRequest(
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
                                myGroupBloc.deleteRequest(
                                    group.requestsAdhesion[index].id, group.id);
                              })
                        ],
                      ));
                })),
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
                          var response = await myGroupBloc.delete(group.id);

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
            label: "Name", component: IconText.iconClickable(text: _groupName)),
        Label(label: "Creator", component: Text(_creatorName)),
        Label(
            label: "Members",
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
      ],
    );
  }

  Widget _buildEditName(Group group) {
    final GlobalKey<FormBuilderState> _editNameFormKey =
        GlobalKey<FormBuilderState>();
    TextEditingController groupNameController;

    return Column(
      children: <Widget>[
        FormBuilder(
          key: _editNameFormKey,
          readOnly: false,
          child: Column(children: <Widget>[
            FormBuilderTextField(
              controller: groupNameController,
              attribute: "name",
              decoration: InputDecoration(labelText: "Name"),
              validators: [
                FormBuilderValidators.required(
                    errorText: "This field is required")
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    if (_editNameFormKey.currentState.saveAndValidate()) {
                      var response = await this
                          .myGroupBloc
                          .editName(groupNameController.text, group.id);
                      if (response.status == 200) {
                        Get.back();
                      } else {
                        DisplaySnackbar.createError(message: response.value);
                      }
                    }
                  }),
            ),
          ]),
        ),
      ],
    );
  }
}
