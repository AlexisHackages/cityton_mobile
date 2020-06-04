import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/screens/profile/subScreens/changePassword.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  ChangePasswordBloc changePasswordBloc = ChangePasswordBloc();

  final GlobalKey<FormBuilderState> _changePasswordFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _verifyNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _verifyNewPasswordController.dispose();
  }

  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Change password",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: Column(
          children: <Widget>[
            FormBuilder(
              key: _changePasswordFormKey,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: _oldPasswordController,
                  attribute: "oldPassword",
                  decoration: InputDecoration(hintText: "Old password"),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required")
                  ],
                ),
                FormBuilderTextField(
                  controller: _newPasswordController,
                  attribute: "newPassword",
                  decoration: InputDecoration(hintText: "New password"),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                  ],
                ),
                FormBuilderTextField(
                  controller: _verifyNewPasswordController,
                  attribute: "verifyNewPassword",
                  decoration: InputDecoration(hintText: "Verify new password"),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                    (val) {
                      if (_newPasswordController.text.trim() !=
                          _verifyNewPasswordController.text.trim()) {
                        return "Passwords are not the same";
                      }
                    },
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                      child: Text('Submit'),
                      onPressed: () async {
                        if (_changePasswordFormKey.currentState
                            .saveAndValidate()) {
                          var response = await this
                              .changePasswordBloc
                              .changePassword(_oldPasswordController.text,
                                  _newPasswordController.text);
                          if (response.status == 200) {
                            Navigator.pop(context);
                          } else {
                            DisplaySnackbar.createError(message: response.value);
                          }
                        }
                      }),
                ),
              ]),
            )
          ],
        ));
  }
}
