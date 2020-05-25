import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  AuthBloc authBloc;

  final GlobalKey<FormBuilderState> _loginFormKey =
      GlobalKey<FormBuilderState>();
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
    return FramePage(
        header: Header(
          title: "Login",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: Column(
          children: <Widget>[
            FormBuilder(
              key: _loginFormKey,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: emailController,
                  attribute: "email",
                  decoration: InputDecoration(labelText: "Email"),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required")
                  ],
                ),
                FormBuilderTextField(
                  controller: passwordController,
                  attribute: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required")
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                      child: Text('Submit'),
                      onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        if (_loginFormKey.currentState.saveAndValidate()) {
                          var response = await this.authBloc.login(
                              emailController.text, passwordController.text);
                          if (response.status == 200) {
                            Navigator.pushNamedAndRemoveUntil(context, '/home',
                                (Route<dynamic> route) => false);
                          } else {
                            DisplaySnackbar.createError(message: response.value);
                          }
                        }
                      }),
                ),
              ]),
            ),
            InkWell(
              child: Text("To signup"),
              onTap: () {
                Navigator.popAndPushNamed(context, '/signup');
              },
            ),
          ],
        ));
  }
}
