import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/icon_text.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
import 'package:cityton_mobile/models/challengeAdmin.dart';
import 'package:cityton_mobile/screens/admin/challenge/adminChallenge.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';

class AddChallenge extends StatefulWidget {
  @override
  AddChallengeState createState() => AddChallengeState();
}

class AddChallengeState extends State<AddChallenge> {
  // AddChallengeBloc adminChallengeBloc = AddChallengeBloc();

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
        sideMenu: null,
        body: Text("ADD CHALLENGE")
      );
  }
}
