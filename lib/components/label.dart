import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  Label({@required this.label, @required this.component});

  final String label;
  final Widget component;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        SizedBox(height: 3.0),
        component,
      ],
    );
  }
}