import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/iconText.dart';
import 'package:cityton_mobile/models/userProfile.dart';
import 'package:cityton_mobile/screens/admin/user/userInfo/UserInfo.bloc.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:get/get.dart';
import 'package:cityton_mobile/models/user.dart';

class UserInfo extends StatefulWidget {
  final Map arguments;

  UserInfo({@required this.arguments});

  @override
  UserInfoState createState() => UserInfoState();
}

class UserInfoState extends State<UserInfo> {
  AuthBloc _authBloc = AuthBloc();
  UserInfoBloc _userInfoBloc = UserInfoBloc();

  UserProfile _userProfile;
  int _selectedRole;
  User _currentUser;
  bool _hasBeenModified = false;

  @override
  void initState() {
    super.initState();
    Map datas = widget.arguments;
    _userProfile = datas["userProfile"];
    _selectedRole = _userProfile.role;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<User> _initCurrentUser() {
    return _authBloc.getCurrentUser();
  }

  changeRole() async {
    if (_userProfile.role != _selectedRole) {
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
    return FutureBuilder<User>(
        future: _initCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _currentUser = snapshot.data;
            return FramePage(
                header: Header(
                  title: "Details " + _userProfile.username,
                  leadingState: HeaderLeading.DEAD_END,
                  resultOnBack: _hasBeenModified,
                  iconsAction: _buildHeaderIconsAction(context),
                ),
                sideMenu: null,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_buildUserInfos()],
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildUserInfos() {
    String roleName = Role.values[_userProfile.role].toString().split('.')[1];
    Widget roleStatus = _userProfile.id == _currentUser.id
        ? IconText.iconNotClickable(
            leading: Icons.people, content: Chip(label: Text('Admin')))
        : IconText.iconNotClickable(
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
                      _hasBeenModified = true;
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
                      _hasBeenModified = true;
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
                      _hasBeenModified = true;
                      changeRole();
                    },
                  )
                ]),
              ],
            ));

    return Column(children: <Widget>[
      CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(_userProfile.picture),
      ),
      IconText.iconNotClickable(
          leading: Icons.perm_identity, content: Text(_userProfile.username)),
      SizedBox(height: space_between_input),
      IconText.iconNotClickable(
          leading: Icons.warning, content: Text(roleName)),
      SizedBox(height: space_between_input),
      IconText.iconNotClickable(
          leading: Icons.mail_outline, content: Text(_userProfile.email)),
      SizedBox(height: space_between_input),
      roleStatus
    ]);
  }

  List<IconButton> _buildHeaderIconsAction(BuildContext context) {
    return _currentUser.id != _userProfile.id
        ? <IconButton>[
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  var response =
                      await this._userInfoBloc.delete(_userProfile.id);

                  if (response.status == 200) {
                    Get.back(result: true);
                  } else {
                    DisplaySnackbar.createError(message: response.value);
                  }
                }),
          ]
        : null;
  }
}
