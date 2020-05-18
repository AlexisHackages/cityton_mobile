import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  Label({@required this.label, @required this.component});

  final String label;
  final Widget component;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label),
        component,
      ],
    );
  }
}