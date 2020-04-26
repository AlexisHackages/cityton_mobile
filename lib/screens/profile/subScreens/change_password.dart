import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/screens/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  ProfileBloc profileBloc = ProfileBloc();

  final GlobalKey<FormBuilderState> _changePasswordFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController verifyNewPasswordController = TextEditingController();

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
                  controller: oldPasswordController,
                  attribute: "oldPassword",
                  decoration: InputDecoration(labelText: "Old password"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required")
                  ],
                ),
                FormBuilderTextField(
                  controller: newPasswordController,
                  attribute: "newPassword",
                  decoration: InputDecoration(labelText: "New password"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                  ],
                ),
                FormBuilderTextField(
                  controller: verifyNewPasswordController,
                  attribute: "verifyNewPassword",
                  decoration: InputDecoration(labelText: "Verify new password"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters"),
                    (val) {
                      if (newPasswordController.text.trim() !=
                          verifyNewPasswordController.text.trim()) {
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
                              .profileBloc
                              .changePassword(oldPasswordController.text,
                                  newPasswordController.text);
                          if (response.status == 200) {
                            Navigator.pop(context);
                          } else {
                            DisplaySnackbar.createError(message: response.value)..show(context);
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
