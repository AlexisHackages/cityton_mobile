import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/icon_text.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/screens/profile/profile_bloc.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Profile extends StatefulWidget {
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
    return FramePage(
        header: Header(
          title: "Profile",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: SideMenu(),
        body: Column(
          children: <Widget>[
            FutureBuilder<User>(
              future: profileBloc.getCurrentUser(),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.picture),
                      ),
                      _buildUserInfos(),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
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
    return Column(
      children: <Widget>[
        IconText(icon: Icons.perm_identity, text: "Username"),
        IconText(icon: Icons.supervisor_account, text: "Group name"),
        IconText(icon: Icons.mail_outline, text: "email"),
      ],
    );
  }
}
