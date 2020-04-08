import 'package:cityton_mobile/form_validators/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/screens/door/auth.bloc.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  AuthBloc authBloc;

  final _loginForm = GlobalKey<FormState>();
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

Widget build(BuildContext context) {
      print("!!!!! WIDGET !!!!!");
      print("!!!!! END WIDGET !!!!!");

  return Column(children: <Widget>[
  Form(
          key: _loginForm,
          autovalidate: true,

          child: ListView(

            children: <Widget>[

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!isValidFormatEmail(value)) {
                    return 'Incorrect email format !';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_loginForm.currentState.validate()) {
                      bool isLogged = await this.authBloc.login(emailController.text, passwordController.text);
                      if (isLogged) {
                        Navigator.pushNamedAndRemoveUntil(context, '/threadsList', (Route<dynamic> route) => false);
                      }
                    }
                  }
                ),
              ),

            ],
          ),
        ),
        RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: 'to signup',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.popAndPushNamed(context, '/signup');
                }),
        ]
      )
        ),
  ]
  );
}
}