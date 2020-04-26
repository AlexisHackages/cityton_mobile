import 'package:flutter/material.dart';

class InputIcon extends StatefulWidget {
  final IconData icon;
  final Function actionOnPressed;

  InputIcon({@required this.icon, this.actionOnPressed});

  @override
  InputIconState createState() => InputIconState();
}

class InputIconState extends State<InputIcon> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          InkWell(
            onTap: () => widget.actionOnPressed(inputController.text),
            child: Icon(widget.icon),
          ),
          Flexible(
              child: TextField(
            controller: inputController,
          )),
        ]);
  }
}
