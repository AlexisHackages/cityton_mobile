import 'package:flutter/material.dart';
import 'package:cityton_mobile/screens/login.dart';
import 'package:cityton_mobile/screens/chat.dart';

final routes = <String, WidgetBuilder>{
  '/login':     (BuildContext context) => Login(),
  '/chat':     (BuildContext context) => Chat(),
  '/' :         (BuildContext context) => Login(),
};