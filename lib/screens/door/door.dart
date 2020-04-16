import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Door extends StatefulWidget {
  @override
  DoorState createState() => DoorState();
}

class DoorState extends State<Door> {

  final FlutterSecureStorage storage = FlutterSecureStorage();

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

    storage.deleteAll();
    
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
            onPressed: () => Navigator.pushNamed(context, '/login'),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
            child: Text("Login"),
          ),
          RaisedButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),),
            child: Text("Signup"),
          ),
        ],
      ),
    ));
  }
}
