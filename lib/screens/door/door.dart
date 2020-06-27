import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Door extends StatefulWidget {
  @override
  DoorState createState() => DoorState();
}

class DoorState extends State<Door> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return FramePage(
      header: Header(
        title: "",
        leadingState: HeaderLeading.NO_LEADING,
      ),
      sideMenu: null,
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Cityton"),
          RaisedButton(
            onPressed: () => Get.toNamed('/login'),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
            child: Text("Login"),
          ),
          RaisedButton(
            onPressed: () => Get.toNamed('/signup'),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
            child: Text("Signup"),
          ),
        ],
      ),
    ));
  }
}
