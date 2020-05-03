import 'package:flutter/material.dart';

class InputIcon extends StatefulWidget {
  final IconData icon;
  final Function actionOnPressed;
  final TextEditingController controller;
  final String labelText;

  InputIcon({@required this.icon, this.actionOnPressed, this.controller, this.labelText});

  @override
  InputIconState createState() => InputIconState();
}

class InputIconState extends State<InputIcon> {

  @override
  Widget build(BuildContext context) {
  TextEditingController inputController = widget.controller == null ? TextEditingController() : widget.controller;

    return Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: inputController,
              decoration: InputDecoration(labelText: widget.labelText),
          )),
          InkWell(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              widget.actionOnPressed(inputController.text);
            },
            child: Icon(widget.icon),
          ),
        ]);
  }
}
