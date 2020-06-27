import 'dart:io';

import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/avatarProfile.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/iconText.dart';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/userProfile.dart';
import 'package:cityton_mobile/screens/profile/profile.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final Map arguments;

  Profile({@required this.arguments});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileBloc _profileBloc = ProfileBloc();

  Widget _avatarProfile;
  int _userId;
  UserProfile _userProfile;
  final ImagePicker _picker = ImagePicker();
  File _filePicked;

  @override
  void initState() {
    super.initState();

    Map datas = widget.arguments;
    _userId = datas["userId"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openGallery() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    _filePicked = File(pickedFile.path);
    if (_filePicked != null) {
      ApiResponse response = await _profileBloc.changePicture(_filePicked);

      if (response.status == 200) {
        setState(() {
          _avatarProfile =
              AvatarProfile(picturePath: _filePicked.path, onPressed: openGallery);
        });
        DisplaySnackbar.createConfirmation(message: "Profile picture updated");
      } else {
        DisplaySnackbar.createError(message: response.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userId != null) {
      return FramePage(
          header: Header(
            title: "Profile",
            leadingState: HeaderLeading.DEAD_END,
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
                  Get.toNamed('/changePassword');
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

  Widget _buildUserInfos() {
    return FutureBuilder<UserProfile>(
        future: _profileBloc.getProfile(_userId),
        builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
          print("PROFILE => " + snapshot.hasData.toString());
          if (snapshot.hasData && snapshot.data != null) {
              _userProfile = snapshot.data;
              return Column(
                children: <Widget>[
                  _buildDetails(),
                ],
              );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildDetails() {
    _avatarProfile =
        AvatarProfile(picturePath: _userProfile.picture, onPressed: openGallery);
    if (_userProfile.role == Role.Member) {
      String groupName = _userProfile.groupName != null
          ? _userProfile.groupName
          : "Is not yet in a group";
      return Column(
        children: <Widget>[
          _avatarProfile,
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.perm_identity, content: Text(_userProfile.username)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.supervisor_account, content: Text(groupName)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.mail_outline, content: Text(_userProfile.email)),
        ],
      );
    } else {
      String role = Role.values[_userProfile.role].toString().split(".")[1];
      return Column(
        children: <Widget>[
          _avatarProfile,
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.perm_identity, content: Text(_userProfile.username)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(leading: Icons.warning, content: Text(role)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.mail_outline, content: Text(_userProfile.email)),
          SizedBox(height: space_between_input),
        ],
      );
    }
  }
}
