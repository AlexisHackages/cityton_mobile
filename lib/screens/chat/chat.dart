import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'chat.bloc.dart';

class Chat extends StatefulWidget {
  final Map arguments;

  Chat({@required this.arguments});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  AuthBloc authBloc = AuthBloc();
  ChatBloc chatBloc = ChatBloc();

  TextEditingController _sendController = TextEditingController();
  User currentUser;

  void initState() {
    super.initState();

    _initCurrentUser();
  }

  Future<void> _initCurrentUser() async {
    currentUser = await authBloc.getCurrentUser();
  }

  @override
  void dispose() {
    // _sendController.dispose();
    // chatBloc.closeMessages();
    // chatBloc.closeChatConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map datas = widget.arguments;
    Thread thread = datas["thread"];

    return FramePage(
      header: Header(
        title: thread.name,
        leadingState: HeaderLeading.MENU,
        iconsAction: _buildHeaderIconsAction(context, thread.discussionId),
      ),
      sideMenu: MainSideMenu(),
      body: _buildChat(thread.discussionId),
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
                onLongPress: () => _buildModalBottomSheet(
                    results[index].content, results[index].id),
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
        child: InputIcon(
      icon: Icons.send,
      controller: _sendController,
      labelText: "Write a message",
      actionOnPressed: (String value) async {
        chatBloc.sendChatMessage(value, threadId, null);
        _sendController.clear();
      },
    ));
  }

  Future<Widget> _buildModalBottomSheet(String content, int messageId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => ListView(
              children: <Widget>[
                ListTile(
                    title: Text("Copy"),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: content));
                      Navigator.pop(context);
                      DisplaySnackbar.createConfirmation(
                          message: "Copied in clipboard")
                        ..show(context);
                    }),
                ListTile(
                    title: Text("Remove"),
                    onTap: () {
                      chatBloc.removeMessage(messageId);
                      Navigator.pop(context);
                      DisplaySnackbar.createConfirmation(
                          message: "Message succesfully Removed")
                        ..show(context);
                    }),
              ],
            ));
  }

  List<IconButton> _buildHeaderIconsAction(BuildContext context, int threadId) {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.flag),
        onPressed: () => Navigator.popAndPushNamed(context, '/chat/progression',
            arguments: {"threadId": threadId}),
      )
    ];
  }
}
