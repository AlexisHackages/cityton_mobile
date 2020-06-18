import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/constants/group.constant.dart';
import 'package:cityton_mobile/models/groupMinimal.dart';
import 'package:cityton_mobile/screens/admin/group/groupManagement.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:get/get.dart';

class GroupManagement extends StatefulWidget {
  @override
  GroupManagementState createState() => GroupManagementState();
}

class GroupManagementState extends State<GroupManagement> {
  GroupManagementBloc _groupManagementBloc = GroupManagementBloc();

  String _searchText = "";
  int _selectedFilter = FilterGroupSize.All.index;

  @override
  void initState() {
    super.initState();
    this._groupManagementBloc.search(_searchText, _selectedFilter);
  }

  @override
  void dispose() {
    super.dispose();
    _groupManagementBloc.closeGroupsStream();
  }

  void search() {
    this._groupManagementBloc.search(_searchText, _selectedFilter);
  }

  void deleteGroup(int groupId) async {
    var response = await _groupManagementBloc.delete(groupId);

    if (response.status == 200) {
      DisplaySnackbar.createConfirmation(message: "Group succesfuly deleted");
      Get.back();
    } else {
      DisplaySnackbar.createConfirmation(message: response.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    search();

    return FramePage(
        header: Header(
          title: "Groups Management",
          leadingState: HeaderLeading.MENU,
        ),
        sideMenu: MainSideMenu(),
        body: StreamBuilder(
            stream: _groupManagementBloc.groups,
            builder: (BuildContext context,
                AsyncSnapshot<List<GroupMinimal>> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 0,
                        child: _buildSearchAndFilter(),
                      ),
                      SizedBox(height: space_after_filter),
                      Flexible(flex: 1, child: _buildGroupList(snapshot.data)),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildSearchAndFilter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputIcon(
            placeholder: _searchText,
            hintText: "Search...",
            iconsAction: <IconAction>[
              IconAction(
                  icon: Icon(Icons.search),
                  action: (String input) {
                    _searchText = input;
                    search();
                  }),
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
              ),
              SizedBox(width: 25.0),
              ChoiceChip(
                label: Text('< minimal size'),
                selected:
                    _selectedFilter == FilterGroupSize.InferiorToMinSize.index,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedFilter = FilterGroupSize.InferiorToMinSize.index;
                  });
                  search();
                },
              ),
            ]))
      ],
    );
  }

  Widget _buildGroupList(List<GroupMinimal> groupsList) {
    if (groupsList.length == 0) {
      return Text("No groups found");
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: groupsList.length,
        itemBuilder: (BuildContext context, int index) {
          final group = groupsList[index];

          Widget warningIcons =
              group.hasReachMaxSize ? Icon(Icons.warning) : Container();

          return ListTile(
              title: Text(group.name),
              onTap: () => Navigator.popAndPushNamed(
                  context, '/admin/group/details',
                  arguments: {"groupId": group.id, "groupName": group.name}),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  group.supervisor == null
                      ? Icon(Icons.warning, color: Colors.redAccent)
                      : Container(),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        deleteGroup(group.id);
                      }),
                  warningIcons
                ],
              ));
        },
      );
    }
  }
}
