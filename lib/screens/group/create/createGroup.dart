import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/screens/group/create/createGroup.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class CreateGroup extends StatefulWidget {
  @override
  CreateGroupState createState() => CreateGroupState();
}

class CreateGroupState extends State<CreateGroup> {
  CreateGroupBloc _createGroupBloc = CreateGroupBloc();

  final GlobalKey<FormBuilderState> _addFormKey = GlobalKey<FormBuilderState>();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void _refreshCurrentUser() async {
    var res = await _createGroupBloc.refreshCurrentUser();
    if (res.status != 200) {
      DisplaySnackbar.createError(message: res.value);
      Get.offAndToNamed('/door');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Create a group",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FormBuilder(
              key: _addFormKey,
              readOnly: false,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  controller: _nameController,
                  attribute: "name",
                  decoration: InputDecoration(hintText: "Name"),
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
                          var response = await this
                              ._createGroupBloc
                              .add(_nameController.text);
                          if (response.status == 200) {
                            _refreshCurrentUser();
                            Get.offAndToNamed('/myGroup');
                            DisplaySnackbar.createConfirmation(
                                message: "Group created");
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
}
