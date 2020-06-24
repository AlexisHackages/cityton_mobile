import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/models/challenge.dart';
import 'package:cityton_mobile/screens/chat/progression/attributeChallenge/attributeChallenge.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:get/get.dart';

class AttributeChallenge extends StatefulWidget {
  final Map arguments;

  AttributeChallenge({@required this.arguments});

  @override
  AttibuteChallengeState createState() => AttibuteChallengeState();
}

class AttibuteChallengeState extends State<AttributeChallenge> {
  AttributeChallengeBloc _attributeChallengeBloc = AttributeChallengeBloc();

  int _threadId;
  String _searchText;
  List<int> _challengesSelected = List();

  @override
  void initState() {
    super.initState();
    Map datas = widget.arguments;
    _threadId = datas["threadId"];
    this._attributeChallengeBloc.search("", _threadId);
  }

  @override
  void dispose() {
    super.dispose();
    _attributeChallengeBloc.closeChallengesStream();
  }

  void search() {
    this._attributeChallengeBloc.search(_searchText, _threadId);
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
        header: Header(
          title: "Attributes challenges",
          leadingState: HeaderLeading.DEAD_END,
        ),
        sideMenu: MainSideMenu(),
        body: StreamBuilder(
            stream: _attributeChallengeBloc.challenges,
            builder: (BuildContext context,
                AsyncSnapshot<List<Challenge>> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 0,
                        child: _buildSearchAndFilter(),
                      ),
                      Flexible(
                          flex: 1, child: _buildChallengeList(snapshot.data)),
                      RaisedButton(
                          child: Text('Submit'),
                          onPressed: () async {
                            if (_challengesSelected.length > 0) {
                              var res = await _attributeChallengeBloc
                                  .attributeToGroup(
                                      _threadId, _challengesSelected);

                              if (res.status == 200) {
                                DisplaySnackbar.createConfirmation(
                                    message:
                                        "Challenges successfuly attributed");
                                Get.back(result: true);
                              } else {
                                DisplaySnackbar.createError(message: res.value);
                              }
                            } else {
                              DisplaySnackbar.createError(
                                  message: "None challenges selected");
                            }
                          })
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget _buildSearchAndFilter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputIcon(
            placeholder: _searchText,
            hintText: "Search...",
            iconsAction: <IconAction>[
              IconAction(
                  icon: Icon(Icons.search),
                  action: (String input) {
                    _searchText = input;
                    search();
                  }),
            ])
      ],
    );
  }

  Widget _buildChallengeList(List<Challenge> challenges) {
    if (challenges.length == 0) {
      return Text("No challenges found");
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: challenges.length,
        itemBuilder: (BuildContext context, int index) {
          final challenge = challenges[index];
          return CheckboxListTile(
            title: Text(challenge.title),
            subtitle: Text(challenge.statement),
            value: _challengesSelected.contains(challenge.id),
            onChanged: (bool selected) {
              setState(() {
                selected ? _challengesSelected.add(challenge.id) : _challengesSelected.remove(challenge.id);
              });
            },
          );
        },
      );
    }
  }
}
