import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  AuthBloc _authBloc = AuthBloc();

  final GlobalKey<FormBuilderState> _loginFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FormBuilder(
              key: _loginFormKey,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: _emailController,
                  attribute: "email",
                  decoration: InputDecoration(
                    hintText: "Email"
                  ),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required")
                  ],
                ),
                SizedBox(height: space_between_input),
                FormBuilderTextField(
                  controller: _passwordController,
                  attribute: "password",
                  decoration: InputDecoration(hintText: "Password"),
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
                          var response = await this._authBloc.login(
                              _emailController.text, _passwordController.text);
                          if (response.status == 200) {
                            Navigator.pushNamedAndRemoveUntil(context, '/home',
                                (Route<dynamic> route) => false);
                          } else {
                            DisplaySnackbar.createError(
                                message: response.value);
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
