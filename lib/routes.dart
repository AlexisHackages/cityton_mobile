import 'package:cityton_mobile/screens/admin/challenge/add/addChallenge.dart';
import 'package:cityton_mobile/screens/admin/challenge/adminChallenge.dart';
import 'package:cityton_mobile/screens/admin/challenge/edit/editChallenge.dart';
import 'package:cityton_mobile/screens/admin/group/groupDetails/AdminGroupDetails.dart';
import 'package:cityton_mobile/screens/admin/group/groupManagement.dart';
import 'package:cityton_mobile/screens/admin/user/UserManagement.dart';
import 'package:cityton_mobile/screens/admin/user/userInfo/UserInfo.dart';
import 'package:cityton_mobile/screens/chat/progression/progression.dart';
import 'package:cityton_mobile/screens/group/allGroups/details/groupDetails.dart';
import 'package:cityton_mobile/screens/group/allGroups/groups.dart';
import 'package:cityton_mobile/screens/group/create/createGroup.dart';
import 'package:cityton_mobile/screens/group/myGroup/editGroup/editGroup.dart';
import 'package:cityton_mobile/screens/group/myGroup/myGroup.dart';
import 'package:cityton_mobile/screens/home/home.dart';
import 'package:cityton_mobile/screens/login/login.dart';
import 'package:cityton_mobile/screens/profile/subScreens/changePassword.dart';
import 'package:cityton_mobile/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/screens/door/door.dart';
import 'package:cityton_mobile/screens/chat/chat.dart';
import 'package:cityton_mobile/screens/profile/profile.dart';

final routes = <String, WidgetBuilder>{
  '/login':                   (BuildContext context) => Login(),
  '/signup':                  (BuildContext context) => Signup(),
  '/door':                    (BuildContext context) => Door(),
  '/home':                    (BuildContext context) => Home(),
  '/chat':                    (BuildContext context) => Chat(arguments: ModalRoute.of(context).settings.arguments),
  '/chat/progression':        (BuildContext context) => Progression(arguments: ModalRoute.of(context).settings.arguments),
  '/profile':                 (BuildContext context) => Profile(arguments: ModalRoute.of(context).settings.arguments),
  '/changePassword':          (BuildContext context) => ChangePassword(),
  '/groups':                  (BuildContext context) => Groups(),
  '/groups/details':          (BuildContext context) => GroupDetails(arguments: ModalRoute.of(context).settings.arguments),
  '/group/create':            (BuildContext context) => CreateGroup(),
  '/myGroup':                 (BuildContext context) => MyGroup(arguments: ModalRoute.of(context).settings.arguments),
  '/myGroup/edit':            (BuildContext context) => EditGroup(arguments: ModalRoute.of(context).settings.arguments),
  '/admin/challenge':         (BuildContext context) => AdminChallenge(),
  '/admin/challenge/add':     (BuildContext context) => AddChallenge(),
  '/admin/challenge/edit':    (BuildContext context) => EditChallenge(arguments: ModalRoute.of(context).settings.arguments),
  '/admin/user':              (BuildContext context) => UserManagement(),
  '/admin/user/userInfo':     (BuildContext context) => UserInfo(arguments: ModalRoute.of(context).settings.arguments),
  '/admin/group':             (BuildContext context) => GroupManagement(),
  '/admin/group/details':     (BuildContext context) => AdminGroupDetails(arguments: ModalRoute.of(context).settings.arguments),
  '/' :                       (BuildContext context) => Door(),
};