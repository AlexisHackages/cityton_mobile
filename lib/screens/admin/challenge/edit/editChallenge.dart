import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/screens/admin/challenge/edit/editChallenge.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class EditChallenge extends StatefulWidget {
  final Map arguments;

  EditChallenge({@required this.arguments});

  @override
  EditChallengeState createState() => EditChallengeState();
}

class EditChallengeState extends State<EditChallenge> {
  EditChallengeBloc _editChallengeBloc = EditChallengeBloc();

  final GlobalKey<FormBuilderState> _editFormKey =
      GlobalKey<FormBuilderState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _statementController = TextEditingController();

  int _challengeId;
  String _challengeTitle;
  String _challengeStatement;

  @override
  void initState() {
    super.initState();
    Map datas = widget.arguments;
    _challengeId = datas["id"];
    _challengeTitle = datas["title"];
    _challengeStatement = datas["statement"];
    _titleController.text = _challengeTitle;
    _statementController.text = _challengeStatement;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _statementController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Edit a challenge",
          leadingState: HeaderLeading.DEAD_END,
          iconsAction: _buildHeaderIconsAction(context, _challengeId),
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
                  controller: _titleController,
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
                  controller: _statementController,
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
                          if (_titleController.text != _challengeTitle &&
                              _statementController.text != _challengeStatement) {
                            Get.back();
                          }

                          var response = await this._editChallengeBloc.edit(
                              _challengeId,
                              _titleController.text,
                              _statementController.text);
                          if (response.status == 200) {
                            Get.back(result: true);
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
            var response = await this._editChallengeBloc.delete(id);

            if (response.status == 200) {
              Get.back(result: true);
            } else {
              DisplaySnackbar.createError(message: response.value);
            }
          }),
    ];
  }
}
