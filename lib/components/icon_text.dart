import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function actionOnTap;

  IconText({@required this.icon, @required this.text, this.actionOnTap});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          IconButton(
            onPressed: () => this.actionOnTap(),
            icon: Icon(icon),
          ),
          Text(text),
        ]);
  }
}
