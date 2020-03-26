import 'package:cityton_mobile/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/side_menu_bloc.dart';
import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/models/thread.dart';

class ThreadsList extends StatefulWidget {
  @override
  ThreadsListState createState() => ThreadsListState();
}

class ThreadsListState extends State<ThreadsList> {
  SideMenuBloc sideMenuBloc = SideMenuBloc();

  @override
  void dispose() {
    sideMenuBloc.closeThreads();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sideMenuBloc.getThreads();

    return FramePage(
        header: Header(title: "ThreadList"),
        sideMenu: SideMenu(),
        body: Center(
          child: _buildMessages(),
        ));
  }

  Widget _buildMessages() {
    sideMenuBloc.getThreads();

    return StreamBuilder(
      stream: sideMenuBloc.threads,
      builder: (BuildContext context, AsyncSnapshot<List<Thread>> snapshot) {
        final results = snapshot.data;

        if (results == null) {
          return Center(child: Text('WAITING...'));
        }

        if (results.isEmpty) {
          return Center(child: Text('PRINT VOID...'));
        }

        return ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  results[index].name,
                  textAlign: TextAlign.center,
                ),
                onTap: () => {
                  Navigator.pushNamed(context, "/chat",
                    arguments: results[index].discussionId),
                }
              );
            });
      },
    );
  }
}
