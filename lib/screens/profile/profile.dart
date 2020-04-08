import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/profile_bloc.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = ProfileBloc();
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(title: "Profile", leadingState: HeaderLeading.DEAD_END,),
        sideMenu: SideMenu(),
        body: Center(
          child: Text("PROFILE PAGE"),
        )
    );
  }
}
