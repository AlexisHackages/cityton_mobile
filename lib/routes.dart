import 'package:cityton_mobile/screens/home/home.dart';
import 'package:cityton_mobile/screens/login/login.dart';
import 'package:cityton_mobile/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/screens/door/door.dart';
import 'package:cityton_mobile/screens/threads_list.dart';
import 'package:cityton_mobile/screens/chat/chat.dart';
import 'package:cityton_mobile/screens/profile/profile.dart';

final routes = <String, WidgetBuilder>{
  '/login':           (BuildContext context) => Login(),
  '/signup':           (BuildContext context) => Signup(),
  '/home':           (BuildContext context) => Home(),
  '/threadsList':     (BuildContext context) => ThreadsList(),
  '/chat':             (BuildContext context) => Chat(),
  '/profile':          (BuildContext context) => Profile(),
  '/' :               (BuildContext context) => Door(),
};