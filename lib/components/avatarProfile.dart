import 'package:flutter/material.dart';

class AvatarProfile extends StatelessWidget {
  final String picturePath;
  final Function onPressed;

  const AvatarProfile({@required this.picturePath, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: RegExp("http").hasMatch(picturePath)
              ? NetworkImage(picturePath)
              : AssetImage(picturePath),
        ),
        Positioned(
            right: -20,
            bottom: -20,
            height: 50.0,
            width: 50.0,
            child: Ink(
                decoration: const ShapeDecoration(
                    color: Colors.pink, shape: CircleBorder()),
                child: IconButton(
                    hoverColor: Colors.pink,
                    icon: Icon(
                      Icons.edit,
                      size: 30,
                    ),
                    onPressed: () {
                      onPressed();
                    })))
      ],
    );
  }
}
