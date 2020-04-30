import 'package:cityton_mobile/components/sideMenu/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'chat.bloc.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  ChatBloc chatBloc;

  TextEditingController _sendController;

  void initState() {
    super.initState();
    chatBloc = new ChatBloc();
    _sendController = TextEditingController();
  }

  @override
  void dispose() {
    _sendController.dispose();
    chatBloc.closeMessages();
    chatBloc.closeChatConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int threadId = ModalRoute.of(context).settings.arguments;

    return FramePage(
      header: Header(title: "Chat"),
      sideMenu: SideMenu(),
      body: _buildChat(threadId),
    );
  }

  Widget _buildChat(int threadId) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(flex: 1, child: _buildMessages(threadId)),
          Container(height: 100, child: _buildInputText(threadId)),
        ],
      ),
      color: Colors.blue,
      alignment: Alignment.center,
    );
  }

  Widget _buildMessages(int threadId) {
    ScrollController _scrollController = ScrollController();

    _scrollToBottom() {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeOut,
        );
      });
    }

    chatBloc.getMessages(threadId);

    return StreamBuilder(
      stream: chatBloc.messages,
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data;

        return ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              _scrollToBottom();
              return ListTile(
                onLongPress: () => _buildModalBottomSheet(results[index].content, results[index].id),
                title: Text(
                  results[index].content,
                  textAlign: TextAlign.center,
                ),
              );
            });
      },
    );
  }

  Widget _buildInputText(int threadId) {
    return Center(
      child: TextField(
        controller: _sendController,
        onSubmitted: (String value) async {
          chatBloc.sendChatMessage(value, threadId, null);
          _sendController.clear();
        },
      ),
    );
  }

  Future<Widget> _buildModalBottomSheet(String content, int messageId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => ListView(
          children: <Widget>[
            ListTile(
              title: Text("Copy"),
              onTap: () => Clipboard.setData(ClipboardData(text: content)),
            ),
            ListTile(
              title: Text("Remove"),
              onTap: () => chatBloc.removeMessage(messageId),
            ),
          ],
            ));
  }
}
