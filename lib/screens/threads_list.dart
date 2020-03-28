import 'package:flutter/material.dart';
import 'package:cityton_mobile/blocs/threads_list_bloc.dart';
import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/models/thread.dart';

class ThreadsList extends StatefulWidget {
  @override
  ThreadsListState createState() => ThreadsListState();
}

class ThreadsListState extends State<ThreadsList> {
  ThreadsListBloc threadsListBloc = ThreadsListBloc();

  @override
  void dispose() {
    threadsListBloc.closeThreads();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FramePage(
        header: Header(title: "ThreadList"),
        sideMenu: SideMenu(),
        body: Center(
          child: _buildThreadsList(),
        ));
  }

  Widget _buildThreadsList() {
    threadsListBloc.getThreads();

    return StreamBuilder(
      stream: threadsListBloc.threads,
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
