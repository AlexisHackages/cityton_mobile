import 'package:flutter/material.dart';

class IconText extends StatelessWidget {

  final IconData icon;
  final String text;

  IconText({@required this.icon, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon),
          Text(text),
        ]);
  }
}
