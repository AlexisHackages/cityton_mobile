import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/screens/admin/challenge/adminChallenge.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddChallenge extends StatefulWidget {
  @override
  AddChallengeState createState() => AddChallengeState();
}

class AddChallengeState extends State<AddChallenge> {
  AdminChallengeBloc adminChallengeBloc = AdminChallengeBloc();

  final GlobalKey<FormBuilderState> _addFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController statementController = TextEditingController();

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
    return FramePage(
        header: Header(
          title: "Add a challenge",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: Column(
          children: <Widget>[
            FormBuilder(
              key: _addFormKey,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: titleController,
                  attribute: "title",
                  decoration: InputDecoration(labelText: "Title"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters are required"),
                    FormBuilderValidators.maxLength(50,
                        errorText: "Maximum 50 characters are allowed"),
                  ],
                ),
                FormBuilderTextField(
                  controller: statementController,
                  attribute: "statement",
                  decoration: InputDecoration(labelText: "Statement"),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(10,
                        errorText: "At least 10 characters are required"),
                    FormBuilderValidators.maxLength(100,
                        errorText: "Maximum 100 characters are allowed"),
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

                        if (_addFormKey.currentState.saveAndValidate()) {
                          var response = await this.adminChallengeBloc.add(
                              titleController.text, statementController.text);
                          if (response.status == 200) {
                            Navigator.pop(context);
                          } else {
                            DisplaySnackbar.createError(message: response.value)
                              ..show(context);
                          }
                        }
                      }),
                ),
              ]),
            ),
          ],
        ));
  }
}
