import 'package:flutter/material.dart';

class IconText {
  static Widget iconClickable(
      {@required Widget content,
      IconButtonCustom leading,
      IconButtonCustom trailing}) {
    if (leading != null && trailing != null) {
      return Row(children: <Widget>[
        IconButton(
          onPressed: () => leading.onAction,
          icon: Icon(leading.icon),
        ),
        content,
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
        content,
      ]);
    } else if (trailing != null) {
      return Row(children: <Widget>[
        content,
        IconButton(
          onPressed: trailing.onAction,
          icon: Icon(trailing.icon),
        ),
      ]);
    } else {
      return Row(children: <Widget>[content]);
    }
  }

  static Widget iconNotClickable(
      {@required Widget content, IconData leading, IconData trailing}) {
    if (leading != null && trailing != null) {
      return Row(children: <Widget>[
        IconButton(
          onPressed: () => null,
          icon: Icon(leading),
        ),
        content,
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
        content,
      ]);
    } else if (trailing != null) {
      return Row(children: <Widget>[
        content,
        IconButton(
          onPressed: () => null,
          icon: Icon(trailing),
        ),
      ]);
    } else {
      return Row(children: <Widget>[content]);
    }
  }
}

class IconButtonCustom {
  IconButtonCustom({@required this.onAction, @required this.icon});

  final VoidCallback onAction;
  final IconData icon;
}
