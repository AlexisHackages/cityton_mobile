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
  UserManagementBloc userManagementBloc = UserManagementBloc();

  String searchText;
  int _selectedRole = -1;

  @override
  void initState() {
    super.initState();
    this.userManagementBloc.search("", _selectedRole);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void search() {
    this.userManagementBloc.search(searchText, _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Challenge",
          leadingState: HeaderLeading.MENU,
        ),
        sideMenu: MainSideMenu(),
        body: StreamBuilder(
            stream: userManagementBloc.userProfiles,
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
    return ExpansionTile(
      title: InputIcon(
        icon: Icons.search,
        actionOnPressed: (value) {
          searchText = value;
          search();
        },
      ),
      children: <Widget>[
        Column(
          children: <Widget>[
            RadioListTile<int>(
              title: const Text('All'),
              value: -1,
              groupValue: _selectedRole,
              onChanged: (int value) { setState(() { _selectedRole = value; }); },
            ),
            RadioListTile<int>(
              title: const Text('Admin'),
              value: Role.Admin.index,
              groupValue: _selectedRole,
              onChanged: (int value) { setState(() { _selectedRole = value; }); },
            ),
            RadioListTile<int>(
              title: const Text('Checker'),
              value: Role.Checker.index,
              groupValue: _selectedRole,
              onChanged: (int value) { setState(() { _selectedRole = value; }); },
            ),
            RadioListTile<int>(
              title: const Text('Member'),
              value: Role.Member.index,
              groupValue: _selectedRole,
              onChanged: (int value) { setState(() { _selectedRole = value; }); },
            ),
          ],
        )
      ],
    );
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
          onTap: () => Navigator.popAndPushNamed(context, '/admin/user/userInfo',
              arguments: {"userProfile": item, }),
        );
      },
    );
  }
}
