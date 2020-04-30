import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/iconText.dart';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/userProfile.dart';
import 'package:cityton_mobile/screens/profile/profile.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/models/enums.dart';

class Profile extends StatefulWidget {
  final Map arguments;

  Profile({@required this.arguments});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileBloc profileBloc = ProfileBloc();

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
    if (datas != null && datas["userId"] != null) {
      return FramePage(
          header: Header(
            title: "Profile",
            leadingState: HeaderLeading.DEAD_END,
          ),
          sideMenu: null,
          body: Column(
            children: <Widget>[
              _buildUserInfos(datas["userId"]),
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
            title: "Profile",
            leadingState: HeaderLeading.DEAD_END,
          ),
          sideMenu: null,
          body: CircularProgressIndicator());
    }
  }

  Widget _buildUserInfos(int userId) {
    return FutureBuilder<ApiResponse>(
        future: profileBloc.getProfile(userId),
        builder: (BuildContext context, AsyncSnapshot<ApiResponse> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data.status == 200) {
              final userProfile = UserProfile.fromJson(data.value);
              return Column(
                children: <Widget>[
                  _buildDetails(userProfile),
                ],
              );
            } else {
              return DisplaySnackbar.createError(message: data.value)
                ..show(context);
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildDetails(UserProfile userProfile) {
    if (userProfile.role == Role.Member) {
      String groupName = userProfile.groupName != null
          ? userProfile.groupName
          : "Is not yet in a group";
      return Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(userProfile.picture),
          ),
          IconText(icon: Icons.perm_identity, text: userProfile.username),
          IconText(icon: Icons.supervisor_account, text: groupName),
          IconText(icon: Icons.mail_outline, text: userProfile.email),
        ],
      );
    } else {
      List<String> role = userProfile.role.toString().split('.');
      return Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(userProfile.picture),
          ),
          IconText(icon: Icons.perm_identity, text: userProfile.username),
          IconText(icon: Icons.warning, text: role[1]),
          IconText(icon: Icons.mail_outline, text: userProfile.email),
        ],
      );
    }
  }
}
