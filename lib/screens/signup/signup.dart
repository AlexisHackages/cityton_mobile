import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Signup extends StatefulWidget {
  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  AuthBloc authBloc;

  final GlobalKey<FormBuilderState> _signupFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController verifyPasswordController;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    verifyPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Signup",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: SideMenu(),
        body: Column(
          children: <Widget>[
            FormBuilder(
              key: _signupFormKey,
              autovalidate: true,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: usernameController,
                  attribute: "username",
                  decoration: InputDecoration(
                      labelText: "Username", hintText: "At least 3 characters"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                  ],
                ),
                FormBuilderTextField(
                  controller: emailController,
                  attribute: "email",
                  decoration: InputDecoration(labelText: "Email"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.email(
                        errorText: "Isn't a valid email format")
                  ],
                ),
                FormBuilderTextField(
                  controller: passwordController,
                  attribute: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                  ],
                ),
                FormBuilderTextField(
                  controller: verifyPasswordController,
                  attribute: "password",
                  decoration: InputDecoration(labelText: "Verify password"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                    (val) {
                      if (passwordController.text !=
                          verifyPasswordController.text)
                        return "Passwords are not the same";
                    },
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                      child: Text('Submit'),
                      onPressed: () async {
                        if (_signupFormKey.currentState.saveAndValidate()) {
                          bool isLogged = await this.authBloc.signup(
                              usernameController.text,
                              emailController.text,
                              passwordController.text,
                              null);
                          if (isLogged) {
                            Navigator.pushNamedAndRemoveUntil(context, '/home',
                                (Route<dynamic> route) => false);
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
