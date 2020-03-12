// import 'package:flutter/material.dart';

// class Login extends StatefulWidget {
//   @override
//   LoginState createState() {
//     return LoginState();
//   }
// }

// class LoginState extends State<Login> {
//   final _loginForm = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//         key: _loginForm,
//         child: Column(children: <Widget>[
//           TextFormField(
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter some Text';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter some Text';
//               }
//               return null;
//             },
//           ),
//           RaisedButton(
//             onPressed: () {
//               // Validate returns true if the form is valid, or false
//               // otherwise.
//               if (_loginForm.currentState.validate()) {
//                 // If the form is valid, display a Snackbar.
//                 Scaffold.of(context)
//                     .showSnackBar(SnackBar(content: Text('Processing Data')));
//               }
//             },
//             child: Text('Submit'),
//           ),
//         ]));
//   }
// }


import 'package:flutter/material.dart';

// Create a Form widget.
class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  
  final _loginForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: _loginForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_loginForm.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}