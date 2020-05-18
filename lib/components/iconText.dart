import 'package:flutter/material.dart';

class IconText {
  static Widget iconClickable(
      {@required String text,
      IconButtonCustom leading,
      IconButtonCustom trailing}) {
    if (leading != null && trailing != null) {
      return Row(children: <Widget>[
        IconButton(
          onPressed: () => leading.onAction,
          icon: Icon(leading.icon),
        ),
        Text(text),
        IconButton(
          onPressed: () => trailing.onAction,
          icon: Icon(trailing.icon),
        )
      ]);
    } else if (leading != null) {
      return Row(children: <Widget>[
        IconButton(
          onPressed: () => leading.onAction,
          icon: Icon(leading.icon),
        ),
        Text(text),
      ]);
    } else if (trailing != null) {
      return Row(children: <Widget>[
        Text(text),
        IconButton(
          onPressed: trailing.onAction,
          icon: Icon(trailing.icon),
        ),
      ]);
    } else {
      return Row(children: <Widget>[Text(text)]);
    }
  }

  static Widget iconNotClickable(
      {@required String text, IconData leading, IconData trailing}) {
    if (leading != null && trailing != null) {
      return Row(children: <Widget>[
        IconButton(
          onPressed: () => null,
          icon: Icon(leading),
        ),
        Text(text),
        IconButton(
          onPressed: () => null,
          icon: Icon(trailing),
        )
      ]);
    } else if (leading != null) {
      return Row(children: <Widget>[
        IconButton(
          onPressed: () => null,
          icon: Icon(leading),
        ),
        Text(text),
      ]);
    } else if (trailing != null) {
      return Row(children: <Widget>[
        Text(text),
        IconButton(
          onPressed: () => null,
          icon: Icon(trailing),
        ),
      ]);
    } else {
      return Row(children: <Widget>[Text(text)]);
    }
  }
}

class IconButtonCustom {
  IconButtonCustom({@required this.onAction, @required this.icon});

  final VoidCallback onAction;
  final IconData icon;
}
