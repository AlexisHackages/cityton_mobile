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
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ApiResponse response = await _profileBloc.changePicture(image);

      if (response.status == 200) {
        setState(() {
          _avatarProfile =
              AvatarProfile(picturePath: image.path, onPressed: openGallery);
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
              _buildUserInfos(_userId),
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
            title: "Profile",
            leadingState: HeaderLeading.DEAD_END,
          ),
          sideMenu: null,
          body: CircularProgressIndicator());
    }
  }

  Widget _buildUserInfos(int userId) {
    return FutureBuilder<ApiResponse>(
        future: _profileBloc.getProfile(userId),
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
              DisplaySnackbar.createError(message: data.value);
              return Container();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildDetails(UserProfile userProfile) {
    _avatarProfile =
        AvatarProfile(picturePath: userProfile.picture, onPressed: openGallery);
    if (userProfile.role == Role.Member) {
      String groupName = userProfile.groupName != null
          ? userProfile.groupName
          : "Is not yet in a group";
      return Column(
        children: <Widget>[
          _avatarProfile,
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.perm_identity, content: Text(userProfile.username)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.supervisor_account, content: Text(groupName)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.mail_outline, content: Text(userProfile.email)),
        ],
      );
    } else {
      List<String> role = userProfile.role.toString().split('.');
      return Column(
        children: <Widget>[
          _avatarProfile,
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.perm_identity, content: Text(userProfile.username)),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(leading: Icons.warning, content: Text(role[1])),
          SizedBox(height: space_between_input),
          IconText.iconNotClickable(
              leading: Icons.mail_outline, content: Text(userProfile.email)),
          SizedBox(height: space_between_input),
        ],
      );
    }
  }
}
