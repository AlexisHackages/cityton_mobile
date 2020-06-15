import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/iconText.dart';
import 'package:cityton_mobile/models/userProfile.dart';
import 'package:cityton_mobile/screens/admin/user/userInfo/UserInfo.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/models/enums.dart';

class UserInfo extends StatefulWidget {
  final Map arguments;

  UserInfo({@required this.arguments});

  @override
  UserInfoState createState() => UserInfoState();
}

class UserInfoState extends State<UserInfo> {
  UserInfoBloc _userInfoBloc = UserInfoBloc();

  UserProfile _userProfile;
  int _selectedRole;

  @override
  void initState() {
    super.initState();
    Map datas = widget.arguments;
    _userProfile = datas["userProfile"];
    _selectedRole = _userProfile.role.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  changeRole() async {
    if (_userProfile.role.index != _selectedRole) {
      var response =
          await _userInfoBloc.changeRole(_userProfile.id, _selectedRole);

      if (response.status == 200) {
        DisplaySnackbar.createConfirmation(
            message: "Role has been successfuly changed");
      } else {
        DisplaySnackbar.createError(message: response.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Details " + _userProfile.username,
          leadingState: HeaderLeading.DEAD_END,
          iconsAction:
              _buildHeaderIconsAction(context),
        ),
        sideMenu: null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildUserInfos(),
            SizedBox(height: space_between_input),
            InkWell(
              child: Text("Change password ?"),
              onTap: () {
                Navigator.pushNamed(context, '/changePassword');
              },
            ),
          ],
        ));
  }

  Widget _buildUserInfos() {
    if (_userProfile.role == Role.Member) {
      String groupName = _userProfile.groupName != null
          ? _userProfile.groupName
          : "Is not yet in a group";
      return Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(_userProfile.picture),
          ),
          IconText.iconNotClickable(
              leading: Icons.perm_identity,
              content: Text(_userProfile.username)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.supervisor_account, content: Text(groupName)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.mail_outline, content: Text(_userProfile.email)),
        ],
      );
    } else {
      List<String> role = _userProfile.role.toString().split('.');
      return Column(children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(_userProfile.picture),
        ),
        IconText.iconNotClickable(
            leading: Icons.perm_identity, content: Text(_userProfile.username)),
        SizedBox(height: space_between_input),
        IconText.iconNotClickable(
            leading: Icons.warning, content: Text(role[1])),
        SizedBox(height: space_between_input),
        IconText.iconNotClickable(
            leading: Icons.mail_outline, content: Text(_userProfile.email)),
        SizedBox(height: space_between_input),
        IconText.iconNotClickable(
            leading: Icons.people,
            content: Row(
              children: <Widget>[
                Row(children: <Widget>[
                  ChoiceChip(
                    label: Text('Member'),
                    selected: _selectedRole == Role.Member.index,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedRole = Role.Member.index;
                      });
                      changeRole();
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
                      changeRole();
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
                      changeRole();
                    },
                  )
                ]),
              ],
            ))
      ]);
    }
  }

  List<IconButton> _buildHeaderIconsAction(BuildContext context) {
    return <IconButton>[
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            var response = await this._userInfoBloc.delete(_userProfile.id);

            if (response.status == 200) {
              Navigator.pop(context);
            } else {
              DisplaySnackbar.createError(message: response.value);
            }
          }),
    ];
  }
}
