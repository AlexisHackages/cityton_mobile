import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
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
              Container(
                width: 160.0,
                child: ChoiceChip(
                  selectedColor: Color(0xff6200ee),
                  label: Text('< minimal size'),
                  selected: _selectedFilter == FilterGroupSize.InferiorToMinSize.index,
                  onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = FilterGroupSize.InferiorToMinSize.index;
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
