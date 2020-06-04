import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/screens/admin/challenge/edit/editChallenge.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EditChallenge extends StatefulWidget {
  final Map arguments;

  EditChallenge({@required this.arguments});

  @override
  EditChallengeState createState() => EditChallengeState();
}

class EditChallengeState extends State<EditChallenge> {
  EditChallengeBloc editChallengeBloc = EditChallengeBloc();

  final GlobalKey<FormBuilderState> _editFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController statementController = TextEditingController();

  Map datas;

  @override
  void initState() {
    super.initState();
    datas = widget.arguments;
    titleController.text = datas["title"];
    statementController.text = datas["statement"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Edit a challenge",
          leadingState: HeaderLeading.DEAD_END,
          iconsAction: _buildHeaderIconsAction(context, datas["id"]),
        ),
        sideMenu: null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FormBuilder(
              key: _editFormKey,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: titleController,
                  attribute: "title",
                  decoration: InputDecoration(labelText: "Title"),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "This field is required"),
                    FormBuilderValidators.minLength(3,
                        errorText: "At least 3 characters are required"),
                    FormBuilderValidators.maxLength(50,
                        errorText: "Maximum 50 characters are allowed"),
                  ],
                ),
                SizedBox(height: space_between_input),
                FormBuilderTextField(
                  controller: statementController,
                  attribute: "statement",
                  decoration: InputDecoration(labelText: "Statement"),
                  maxLines: 1,
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

                        if (_editFormKey.currentState.saveAndValidate()) {
                          if (titleController.text != datas["title"] &&
                              statementController.text != datas["statement"]) {
                            Navigator.pop(context);
                          }

                          var response = await this.editChallengeBloc.edit(
                              datas["id"],
                              titleController.text,
                              statementController.text);
                          if (response.status == 200) {
                            Navigator.pop(context);
                          } else {
                            DisplaySnackbar.createError(
                                message: response.value);
                          }
                        }
                      }),
                ),
              ]),
            ),
          ],
        ));
  }

  List<IconButton> _buildHeaderIconsAction(BuildContext context, int id) {
    return <IconButton>[
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            var response = await this.editChallengeBloc.delete(id);

            if (response.status == 200) {
              Navigator.pop(context);
            } else {
              DisplaySnackbar.createError(message: response.value);
            }
          }),
    ];
  }
}
