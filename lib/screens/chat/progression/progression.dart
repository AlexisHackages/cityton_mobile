import 'package:cityton_mobile/models/challengeMinimal.dart';
import 'package:cityton_mobile/models/groupProgression.dart';
import 'package:cityton_mobile/screens/chat/progression/progression.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Progression extends StatefulWidget {
  final Map arguments;

  Progression({@required this.arguments});

  @override
  ProgressionState createState() => ProgressionState();
}

class ProgressionState extends State<Progression> {
  ProgressionBloc progressionBloc = ProgressionBloc();

  Map datas;

  @override
  void initState() {
    super.initState();
    datas = widget.arguments;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder<GroupProgression>(
            future: progressionBloc.getProgression(datas["threadId"]),
            builder: (BuildContext context, AsyncSnapshot<GroupProgression> snapshot) {
              return ListView(children: [
                _buildDrawHeader(snapshot),
                ..._buildDrawBody(snapshot),
              ]);
            }));
  }

  Widget _buildDrawHeader(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      GroupProgression groupProgression = snapshot.data;
      return DrawerHeader(
          child: Padding(
              padding: EdgeInsets.all(25.0),
              child: LinearProgressIndicator(
                value: groupProgression.progression,
              )));
    } else {
      return CircularProgressIndicator();
    }
  }

  List<Widget> _buildDrawBody(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      GroupProgression groupProgression = snapshot.data;

      return <Widget>[
        _buildCategory(groupProgression.inProgress, "In progress"),
        _buildCategory(groupProgression.succeed, "Succeed"),
        _buildCategory(groupProgression.failed, "Failed"),
      ];
    } else {
      return <Widget>[CircularProgressIndicator()];
    }
  }

  Widget _buildCategory(List<ChallengeMinimal> challenges, String title) {
    return ExpansionTile(title: Text(title), children: <Widget>[
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
            );
          })
    ]);
  }
}
