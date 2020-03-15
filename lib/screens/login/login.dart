import 'package:flutter/material.dart';
import 'package:cityton_mobile/form_validators/user.dart';
import 'package:cityton_mobile/blocs/login_bloc.dart';

// Create a Form widget.
class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  LoginBloc loginBloc = new LoginBloc();

  final _loginForm = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

        appBar: new AppBar(
          title: new Text("IMATitle"),
        ),

        body: Form(
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
                      print("!!!!! UI !!!!!");
                      print(emailController.text);
                      print(passwordController.text);
                      print("!!!!! END UI !!!!!");

                      var jwt = await this.loginBloc.login(emailController.text, passwordController.text);
                      print(jwt);
                    }
                  }
                ),
              ),

            ],
          ),
        ));
  }
}
