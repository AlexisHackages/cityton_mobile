import 'package:flutter/material.dart';
import 'package:cityton_mobile/routes.dart';
import 'package:cityton_mobile/theme/style.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

void main() => {
  Stetho.initialize(),
  runApp(MyApp()),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cityton',
      theme: appTheme(),
      initialRoute: '/',
      routes: routes,
    );
  }
}