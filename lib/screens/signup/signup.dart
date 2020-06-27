import 'dart:io';
import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/avatarProfile.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  AuthBloc _authBloc = AuthBloc();

  final GlobalKey<FormBuilderState> _signupFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();
  File _profilePicture = File(DotEnv().env['DEFAULT_PROFILE_PICTURE']);

  Widget _avatarProfile;

  @override
  void initState() {
    super.initState();
    _avatarProfile = AvatarProfile(
        picturePath: _profilePicture.path, onPressed: openGallery);
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
  }

  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _profilePicture = image;
      setState(() {
        _avatarProfile = AvatarProfile(
            picturePath: _profilePicture.path, onPressed: openGallery);
      });
    }
  }

  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Signup",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _avatarProfile,
            FormBuilder(
              key: _signupFormKey,
              autovalidate: true,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: _usernameController,
                  attribute: "username",
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                  ],
                ),
                SizedBox(height: space_between_input),
                FormBuilderTextField(
                  controller: _emailController,
                  attribute: "email",
                  decoration: InputDecoration(hintText: "Email"),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.email(
                        errorText: "Isn't a valid email format")
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
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                  ],
                ),
                SizedBox(height: space_between_input),
                FormBuilderTextField(
                  controller: _verifyPasswordController,
                  attribute: "verifyPassword",
                  decoration: InputDecoration(hintText: "Verify password"),
                  obscureText: true,
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                    (val) {
                      if (_passwordController.text !=
                          _verifyPasswordController.text)
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
                          var response = await this._authBloc.signup(
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _profilePicture.path == DotEnv().env['DEFAULT_PROFILE_PICTURE'] ? null : _profilePicture);
                          if (response.status == 200) {
                            Get.offNamedUntil('/home',
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
              child: Text("To login"),
              onTap: () {
                Get.offAndToNamed('/login');
              },
            ),
          ],
        ))));
  }
}
