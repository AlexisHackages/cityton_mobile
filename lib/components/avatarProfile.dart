import 'package:flutter/material.dart';

class AvatarProfile extends StatelessWidget {
  final String picturePath;
  final Function onPressed;

  const AvatarProfile({@required this.picturePath, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    print("!!!!! AVATAR !!!!!");
    print(picturePath);
    print("!!!!! END AVATAR !!!!!");
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: RegExp("http").hasMatch(picturePath) ? NetworkImage(picturePath) : AssetImage(picturePath),
        ),
        Positioned(
            right: -20,
            top: -20,
            height: 50.0,
            width: 50.0,
            child: IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  size: 30,
                ),
                onPressed: () {
                  onPressed();
                }))
      ],
      overflow: Overflow.visible,
    );
  }
}
