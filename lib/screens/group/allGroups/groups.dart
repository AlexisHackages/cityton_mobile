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

import 'groups.bloc.dart';

class Groups extends StatefulWidget {
  @override
  GroupsState createState() => GroupsState();
}

class GroupsState extends State<Groups> {
  AuthBloc authBloc = AuthBloc();
  GroupsBloc groupsBloc = GroupsBloc();

  User currentUser;
  int _selectedFilter = FilterGroupSize.All.index;
  String searchText = "";

  void initState() {
    super.initState();

    _initCurrentUser();
  }

  Future<void> _initCurrentUser() async {
    currentUser = await authBloc.getCurrentUser();
  }

  void search() {
    groupsBloc.search(searchText, _selectedFilter);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    search();

    return FramePage(
        header: Header(
          title: "All Groups",
          leadingState: HeaderLeading.MENU,
          iconsAction: _buildHeaderIconsAction(context),
        ),
        sideMenu: MainSideMenu(),
        body: StreamBuilder(
            stream: groupsBloc.groups,
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
                      Flexible(flex: 1, child: _buildGroupList(snapshot.data)),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildFilter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputIcon(
          icon: Icons.search,
          placeholder: searchText,
          actionOnPressed: (value) {
            searchText = value;
            search();
          },
        ),
        SizedBox(
          height: 44.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 160.0,
                child: ChoiceChip(
                  selectedColor: Color(0xff6200ee),
                  label: Text('All'),
                  selected: _selectedFilter == FilterGroupSize.All.index,
                  onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = FilterGroupSize.All.index;
                      });
                      search();
                    },),
              ),
              Container(
                width: 160.0,
                child: ChoiceChip(
                  selectedColor: Color(0xff6200ee),
                  label: Text('Full'),
                  selected: _selectedFilter == FilterGroupSize.Full.index,
                  onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = FilterGroupSize.Full.index;
                      });
                      search();
                    },),
              ),
              Container(
                width: 160.0,
                child: ChoiceChip(
                  selectedColor: Color(0xff6200ee),
                  label: Text('Not Full'),
                  selected: _selectedFilter == FilterGroupSize.NotFull.index,
                  onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = FilterGroupSize.NotFull.index;
                      });
                      search();
                    },),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildGroupList(List<GroupMinimal> groupsList) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: groupsList.length,
      itemBuilder: (BuildContext context, int index) {
        final item = groupsList[index];

        Widget createRequest = Role.values[currentUser.role] == Role.Member &&
                currentUser.groupId < 1
            ? IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  var response = await groupsBloc.createRequest(item.id);

                  if (response.status == 200) {
                    DisplaySnackbar.createConfirmation(message: "Request sent");
                  } else {
                    DisplaySnackbar.createConfirmation(message: response.value);
                  }
                })
            : null;

        return ListTile(
            title: Text(item.name),
            onTap: () => Navigator.popAndPushNamed(context, '/groups/details',
                arguments: {"groupId": item.id, "groupName": item.name}),
            trailing: createRequest);
      },
    );
  }

  List<IconButton> _buildHeaderIconsAction(BuildContext context) {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () => Navigator.popAndPushNamed(context, '/group/create'),
      )
    ];
  }
}
