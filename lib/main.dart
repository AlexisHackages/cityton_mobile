import 'package:flutter/material.dart';
import 'package:cityton_mobile/routes.dart';
import 'package:cityton_mobile/theme/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

Future main() async => {
  await DotEnv().load('.env'),
  Stetho.initialize(),
  runApp(MyApp()),
};

class MyApp extends StatelessWidget {
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