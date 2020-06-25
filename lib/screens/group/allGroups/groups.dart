import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/constants/group.constant.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:cityton_mobile/models/groupMinimal.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:get/get.dart';
import 'groups.bloc.dart';

class Groups extends StatefulWidget {
  @override
  GroupsState createState() => GroupsState();
}

class GroupsState extends State<Groups> {
  AuthBloc _authBloc = AuthBloc();
  GroupsBloc _groupsBloc = GroupsBloc();

  User _currentUser;
  int _selectedFilter = FilterGroupSize.All.index;
  String _searchText = "";

  void initState() {
    super.initState();

    _initCurrentUser();
  }

  Future<User> _initCurrentUser() async {
    return _currentUser = await _authBloc.getCurrentUser();
  }

  void _refreshCurrentUser() async {
    var res = await _groupsBloc.refreshCurrentUser();
    if (res.status == 200) {
      setState(() {
        _currentUser = User.fromJson(res.value);
      });
    } else {
      DisplaySnackbar.createError(message: res.value);
      Get.toNamed('/door');
    }
  }

  void search() {
    _groupsBloc.search(_searchText, _selectedFilter);
  }

  @override
  void dispose() {
    super.dispose();
    _groupsBloc.closeGroupStream();
  }

  @override
  Widget build(BuildContext context) {
    search();

    return FutureBuilder<User>(
        future: _initCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _currentUser = snapshot.data;
            return FramePage(
                header: Header(
                  title: "All Groups",
                  leadingState: HeaderLeading.MENU,
                  iconsAction: _buildHeaderIconsAction(context),
                ),
                sideMenu: MainSideMenu(),
                body: StreamBuilder(
                    stream: _groupsBloc.groups,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<GroupMinimal>> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 0,
                                child: _buildFilter(),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: _buildGroupList(snapshot.data)),
                            ],
                          ),
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

  Widget _buildFilter() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      InputIcon(placeholder: _searchText, iconsAction: <IconAction>[
        IconAction(
            icon: Icon(Icons.search),
            action: (String input) {
              _searchText = input;
              search();
            })
      ]),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: <Widget>[
            ChoiceChip(
              label: Text('All'),
              selected: _selectedFilter == FilterGroupSize.All.index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedFilter = FilterGroupSize.All.index;
                });
                search();
              },
            ),
            SizedBox(width: 25.0),
            ChoiceChip(
              label: Text('Full'),
              selected: _selectedFilter == FilterGroupSize.Full.index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedFilter = FilterGroupSize.Full.index;
                });
                search();
              },
            ),
            SizedBox(width: 25.0),
            ChoiceChip(
              label: Text('Not Full'),
              selected: _selectedFilter == FilterGroupSize.NotFull.index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedFilter = FilterGroupSize.NotFull.index;
                });
                search();
              },
            )
          ]))
    ]);
  }

  Widget _buildGroupList(List<GroupMinimal> groupsList) {
    return groupsList.length > 0 ? ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: groupsList.length,
      itemBuilder: (BuildContext context, int index) {
        final group = groupsList[index];

        Widget createRequest = Role.values[_currentUser.role] == Role.Member &&
                _currentUser.groupId < 1 &&
                !_currentUser.groupIdsRequested.contains(group.id) &&
                !group.hasReachMaxSize
            ? IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  var response = await _groupsBloc.createRequest(group.id);

                  if (response.status == 200) {
                    _refreshCurrentUser();
                    DisplaySnackbar.createConfirmation(message: "Request sent");
                  } else {
                    DisplaySnackbar.createError(message: response.value);
                  }
                })
            : null;

        return ListTile(
            title: Text(group.name),
            onTap: () => Get.toNamed('/groups/details',
                arguments: {"groupId": group.id, "groupName": group.name}),
            trailing: createRequest);
      },
    )
    : Text("No results was found");
  }

  List<IconButton> _buildHeaderIconsAction(BuildContext context) {
    if (Role.values[_currentUser.role] == Role.Member &&
        _currentUser.groupId < 1) {
      return <IconButton>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Get.toNamed('/group/create'),
        )
      ];
    } else {
      return List<IconButton>();
    }
  }
}
