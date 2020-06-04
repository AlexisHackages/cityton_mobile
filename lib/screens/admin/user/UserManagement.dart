import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:cityton_mobile/models/userProfile.dart';
import 'package:cityton_mobile/screens/admin/user/UserManagement.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class UserManagement extends StatefulWidget {
  @override
  UserManagementState createState() => UserManagementState();
}

class UserManagementState extends State<UserManagement> {
  UserManagementBloc _userManagementBloc = UserManagementBloc();

  String _searchText;
  int _selectedRole = -1;

  @override
  void initState() {
    super.initState();
    this._userManagementBloc.search("", _selectedRole);
  }

  @override
  void dispose() {
    super.dispose();
    _userManagementBloc.closeUserProfilesStream();
  }

  void search() {
    this._userManagementBloc.search(_searchText, _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "User management",
          leadingState: HeaderLeading.MENU,
        ),
        sideMenu: MainSideMenu(),
        body: StreamBuilder(
            stream: _userManagementBloc.userProfiles,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserProfile>> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 0,
                        child: _buildSearchAndFilter(),
                      ),
                      Flexible(flex: 1, child: _buildUserList(snapshot.data)),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildSearchAndFilter() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
              selected: _selectedRole == -1,
              onSelected: (bool selected) {
                setState(() {
                  _selectedRole = -1;
                });
                search();
              },
            ),
            SizedBox(width: 25.0),
            ChoiceChip(
              label: Text('Admin'),
              selected: _selectedRole == Role.Admin.index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedRole = Role.Admin.index;
                });
                search();
              },
            ),
            SizedBox(width: 25.0),
            ChoiceChip(
              label: Text('Checker'),
              selected: _selectedRole == Role.Checker.index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedRole = Role.Checker.index;
                });
                search();
              },
            ),
            SizedBox(width: 25.0),
            ChoiceChip(
              label: Text('Member'),
              selected: _selectedRole == Role.Member.index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedRole = Role.Member.index;
                });
                search();
              },
            )
          ]))
    ]);
  }

  Widget _buildUserList(List<UserProfile> userProfiles) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: userProfiles.length,
      itemBuilder: (BuildContext context, int index) {
        final item = userProfiles[index];

        return ListTile(
          title: Text(item.username),
          onTap: () => Navigator.popAndPushNamed(
              context, '/admin/user/userInfo',
              arguments: {
                "userProfile": item,
              }),
        );
      },
    );
  }
}
