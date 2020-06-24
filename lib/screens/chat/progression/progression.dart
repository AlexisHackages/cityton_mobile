import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/challengeMinimal.dart';
import 'package:cityton_mobile/models/enums.dart';
import 'package:cityton_mobile/models/groupProgression.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/screens/chat/progression/progression.bloc.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Progression extends StatefulWidget {
  final Map arguments;

  Progression({@required this.arguments});

  @override
  ProgressionState createState() => ProgressionState();
}

class ProgressionState extends State<Progression> {
  AuthBloc _authBloc = AuthBloc();
  ProgressionBloc _progressionBloc = ProgressionBloc();

  User _currentUser;
  Future<GroupProgression> groupProgression;
  int _threadId;

  @override
  void initState() {
    super.initState();
    Map datas = widget.arguments;
    _threadId = datas["threadId"];
  }

  @override
  void dispose() {
    super.dispose();
    _progressionBloc.closeGroupProgression();
  }

  Future<User> _initCurrentUser() async {
    return await _authBloc.getCurrentUser();
  }

  _refreshProgression() async {
    ApiResponse response = await _progressionBloc.getProgression(_threadId);

    if (response.status != 200) {
      DisplaySnackbar.createError(message: response.value);
    }
  }

  validate(int challengeId) async {
    ApiResponse response =
        await _progressionBloc.validate(challengeId, _threadId);

    if (response.status == 200) {
      DisplaySnackbar.createConfirmation(message: "Challenge validated");
    } else {
      DisplaySnackbar.createError(message: response.value);
    }
  }

  reject(int challengeId) async {
    ApiResponse response =
        await _progressionBloc.reject(challengeId, _threadId);

    if (response.status == 200) {
      DisplaySnackbar.createConfirmation(message: "Challenge rejected");
    } else {
      DisplaySnackbar.createError(message: response.value);
    }
  }

  undo(int challengeId) async {
    ApiResponse response = await _progressionBloc.undo(challengeId, _threadId);

    if (response.status == 200) {
      DisplaySnackbar.createConfirmation(message: "Challenge successfuly undo");
    } else {
      DisplaySnackbar.createError(message: response.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    _refreshProgression();
    return FutureBuilder<User>(
        future: _initCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _currentUser = snapshot.data;
            return FramePage(
                header: Header(
                  title: "Details",
                  leadingState: HeaderLeading.DEAD_END,
                  iconsAction: _buildHeaderIconsAction(),
                ),
                sideMenu: null,
                body: StreamBuilder(
                    stream: _progressionBloc.groupProgression,
                    builder: (BuildContext context,
                        AsyncSnapshot<GroupProgression> snapshot) {
                      return ListView(children: [
                        _buildDrawHeader(snapshot),
                        ..._buildDrawBody(snapshot),
                      ]);
                    }));
          } else {
            return FramePage(
                header: Header(
                  title: "Details",
                  leadingState: HeaderLeading.DEAD_END,
                ),
                sideMenu: null,
                body: CircularProgressIndicator());
          }
        });
  }

  List<IconButton> _buildHeaderIconsAction() {
    return Role.values[_currentUser.role] == Role.Admin
        ? <IconButton>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Get.toNamed('/chat/progression/attributeChallenge',
                          arguments: {"threadId": _threadId})
                      .then((value) => value == null
                          ? null
                          : value ? _refreshProgression() : null);
                })
          ]
        : null;
  }

  Widget _buildDrawHeader(AsyncSnapshot snapshot) {
    if (snapshot.hasData && snapshot.data.groupId != null) {
      GroupProgression groupProgression = snapshot.data;
      return Container(
          padding: EdgeInsets.all(30.0),
          child: Column(children: <Widget>[
            Text(groupProgression.progression.toInt().toString() +
                "% achievements earned"),
            LinearProgressIndicator(
              value: groupProgression.progression / 100.0,
              backgroundColor: Colors.blueGrey[700],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }

  List<Widget> _buildDrawBody(AsyncSnapshot snapshot) {
    if (snapshot.hasData && snapshot.data.groupId != null) {
      GroupProgression groupProgression = snapshot.data;

      return <Widget>[
        _buildCategory(groupProgression.inProgress, StatusChallenge.InProgress),
        _buildCategory(groupProgression.succeed, StatusChallenge.Succeed),
        _buildCategory(groupProgression.failed, StatusChallenge.Failed),
        SizedBox(height: space_around_divider),
      ];
    } else {
      return <Widget>[CircularProgressIndicator()];
    }
  }

  Widget _buildCategory(
      List<ChallengeMinimal> challenges, StatusChallenge status) {
    return ExpansionTile(
        title: Text(
          status.value,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: challenges.length == 0
            ? <Widget>[
                Text("No challenges found"),
                SizedBox(height: space_between_input),
              ]
            : <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: challenges.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          challenges[index].title,
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(challenges[index].statement,
                            textAlign: TextAlign.center),
                        trailing: Role.values[_currentUser.role] == Role.Member
                            ? null
                            : Column(
                                children:
                                    _buildButtons(status, challenges[index].id),
                              ),
                      );
                    })
              ]);
  }

  List<Widget> _buildButtons(StatusChallenge status, int challengeId) {
    if (status == StatusChallenge.InProgress) {
      return [
        InkWell(
          onTap: () {
            validate(challengeId);
          },
          child: Icon(Icons.done),
        ),
        InkWell(
          onTap: () {
            reject(challengeId);
          },
          child: Icon(Icons.clear),
        ),
      ];
    } else if (status == StatusChallenge.Succeed) {
      return [
        InkWell(
          onTap: () {
            undo(challengeId);
          },
          child: Icon(Icons.refresh),
        ),
      ];
    } else if (status == StatusChallenge.Failed) {
      return [
        InkWell(
          onTap: () {
            undo(challengeId);
          },
          child: Icon(Icons.refresh),
        ),
      ];
    } else {
      return null;
    }
  }
}
