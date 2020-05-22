import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/constants/group.constant.dart';
import 'package:cityton_mobile/models/groupMinimal.dart';
import 'package:cityton_mobile/screens/admin/group/groupManagement.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class GroupManagement extends StatefulWidget {
  @override
  GroupManagementState createState() => GroupManagementState();
}

class GroupManagementState extends State<GroupManagement> {
  GroupManagementBloc _groupManagementBloc = GroupManagementBloc();

  String searchText = "";
  int _selectedFilter = FilterGroupSize.All.index;

  @override
  void initState() {
    super.initState();
    this._groupManagementBloc.search(searchText, _selectedFilter);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void search() {
    this._groupManagementBloc.search(searchText, _selectedFilter);
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
    return ExpansionTile(
      title: Text("Filter"),
      children: <Widget>[
        Column(
          children: <Widget>[
            RadioListTile<int>(
              title: const Text('All'),
              value: FilterGroupSize.All.index,
              groupValue: _selectedFilter,
              onChanged: (int value) {
                setState(() {
                  _selectedFilter = value;
                });
                search();
              },
            ),
            RadioListTile<int>(
              title: const Text('Full'),
              value: FilterGroupSize.Full.index,
              groupValue: _selectedFilter,
              onChanged: (int value) {
                setState(() {
                  _selectedFilter = value;
                });
                search();
              },
            ),
            RadioListTile<int>(
              title: const Text('Not full'),
              value: FilterGroupSize.NotFull.index,
              groupValue: _selectedFilter,
              onChanged: (int value) {
                setState(() {
                  _selectedFilter = value;
                });
                search();
              },
            ),
            RadioListTile<int>(
              title: const Text('< minimal size'),
              value: FilterGroupSize.InferiorToMinSize.index,
              groupValue: _selectedFilter,
              onChanged: (int value) {
                setState(() {
                  _selectedFilter = value;
                });
                search();
              },
            ),
          ],
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
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      var response =
                          await _groupManagementBloc.delete(group.id);

                      if (response.status == 200) {
                        DisplaySnackbar.createConfirmation(
                            message: "Group succesfuly deleted");
                      } else {
                        DisplaySnackbar.createConfirmation(
                            message: response.value);
                      }
                    }),
                warningIcons
              ],
            ));
      },
    );
  }
}
