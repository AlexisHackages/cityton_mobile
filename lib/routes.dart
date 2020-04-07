import 'package:flutter/material.dart';
import 'package:cityton_mobile/screens/login.dart';
import 'package:cityton_mobile/screens/threads_list.dart';
import 'package:cityton_mobile/screens/chat.dart';
import 'package:cityton_mobile/screens/profile.dart';

final routes = <String, WidgetBuilder>{
  '/login':           (BuildContext context) => Login(),
  '/threadsList':     (BuildContext context) => ThreadsList(),
  '/chat':             (BuildContext context) => Chat(),
  '/profile':          (BuildContext context) => Profile(),
  '/' :               (BuildContext context) => Login(),
};