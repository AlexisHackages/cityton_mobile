import 'package:flutter/material.dart';
import 'package:cityton_mobile/components/frame_page.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/components/side_menu.dart';
import 'package:cityton_mobile/blocs/chat_bloc.dart';
import 'package:cityton_mobile/models/message.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  ChatBloc chatBloc = ChatBloc();

  @override
  void dispose() {
    chatBloc.closeMessages();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int args = ModalRoute.of(context).settings.arguments;

    return FramePage(
        header: Header(title: "Chat"),
        sideMenu: SideMenu(),
        body: _buildChat(args),
        );
  }

  Widget _buildChat(int threadId) {
    print("!!!!! BUILDER !!!!!");
    print(threadId);
    print(_buildMessages(threadId));
    print("!!!!! END BUILDER !!!!!");
    return Container (
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: _buildMessages(threadId)
          ),
          Container(
            height: 100,
            child: TextField()
          ),
          // _buildInputText(),
        ],
      ),
      color: Colors.blue,
      alignment: Alignment.center,
    );
  }

  Widget _buildMessages(int threadId) {
    chatBloc.getMessages(threadId);

    return StreamBuilder(
      stream: chatBloc.messages,
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
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
                  results[index].content,
                  textAlign: TextAlign.center,
                ),
              );
            });

        // return ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: results.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return ListTile(
        //         title: Text(
        //           results[index].content,
        //           textAlign: TextAlign.center,
        //         ),
        //       );
        //     });
      },
    );
  }
}
