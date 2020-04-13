import 'package:cityton_mobile/constants/door.constants.dart';
import 'package:cityton_mobile/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/screens/door/door.dart';
import 'package:cityton_mobile/screens/threads_list.dart';
import 'package:cityton_mobile/screens/chat/chat.dart';
import 'package:cityton_mobile/screens/profile/profile.dart';

final routes = <String, WidgetBuilder>{
  '/login':           (BuildContext context) => Door(showBody: ShowBody.LOGIN),
  '/signup':           (BuildContext context) => Door(showBody: ShowBody.SIGNUP),
  '/home':           (BuildContext context) => Home(),
  '/threadsList':     (BuildContext context) => ThreadsList(),
  '/chat':             (BuildContext context) => Chat(),
  '/profile':          (BuildContext context) => Profile(),
  '/' :               (BuildContext context) => Door(showBody: ShowBody.LOGIN),
};