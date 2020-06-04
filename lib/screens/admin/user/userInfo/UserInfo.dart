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
  UserInfoBloc userInfoBloc = UserInfoBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map datas = widget.arguments;
    UserProfile user = datas["userProfile"];

    if (datas != null) {
      return FramePage(
          header: Header(
            title: "Details " + user.username,
            leadingState: HeaderLeading.DEAD_END,
            iconsAction:
                _buildHeaderIconsAction(context, datas["userProfile"].id),
          ),
          sideMenu: null,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildUserInfos(user),
              SizedBox(height: space_between_input),
              InkWell(
                child: Text("Change password ?"),
                onTap: () {
                  Navigator.pushNamed(context, '/changePassword');
                },
              ),
            ],
          ));
    } else {
      return FramePage(
          header: Header(
            title: "Details " + user.username,
            leadingState: HeaderLeading.DEAD_END,
          ),
          sideMenu: null,
          body: CircularProgressIndicator());
    }
  }

  Widget _buildUserInfos(UserProfile userProfile) {
    if (userProfile.role == Role.Member) {
      String groupName = userProfile.groupName != null
          ? userProfile.groupName
          : "Is not yet in a group";
      return Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(userProfile.picture),
          ),
          IconText.iconNotClickable(
              leading: Icons.perm_identity, text: userProfile.username),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.supervisor_account, text: groupName),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.mail_outline, text: userProfile.email),
        ],
      );
    } else {
      List<String> role = userProfile.role.toString().split('.');
      return Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(userProfile.picture),
          ),
          IconText.iconNotClickable(
              leading: Icons.perm_identity, text: userProfile.username),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(leading: Icons.warning, text: role[1]),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.mail_outline, text: userProfile.email),
        ],
      );
    }
  }

  List<IconButton> _buildHeaderIconsAction(BuildContext context, int id) {
    return <IconButton>[
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            var response = await this.userInfoBloc.delete(id);

            if (response.status == 200) {
              Navigator.pop(context);
            } else {
              DisplaySnackbar.createError(message: response.value);
            }
          }),
    ];
  }
}
