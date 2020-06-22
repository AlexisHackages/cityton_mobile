import 'dart:io';
import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/components/inputIcon.dart';
import 'package:cityton_mobile/components/mainSideMenu/mainSideMenu.dart';
import 'package:cityton_mobile/constants/header.constants.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:flutter/material.dart';
import 'package:cityton_mobile/components/framePage.dart';
import 'package:cityton_mobile/components/header.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'chat.bloc.dart';

class Chat extends StatefulWidget {
  final Map arguments;

  Chat({@required this.arguments});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  ChatBloc _chatBloc = ChatBloc();

  TextEditingController _sendController = TextEditingController();
  File _filePicked;

  Widget _popupFileSelected = Container();
  Thread _thread;

  void initState() {
    super.initState();

    Map datas = widget.arguments;
    _thread = datas["thread"];
  }

  void openGallery() async {
    File media = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (media != null) {
      _filePicked = media;
      setState(() {
        _popupFileSelected = _buildFileSelected();
      });
    }
  }

  void openCamera() async {
    File media = await ImagePicker.pickImage(source: ImageSource.camera);
    if (media != null) {
      _filePicked = media;
      setState(() {
        _popupFileSelected = _buildFileSelected();
      });
    }
  }

  @override
  void dispose() {
    _sendController.dispose();
    _chatBloc.closeMessages();
    _chatBloc.closeChatConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FramePage(
      header: Header(
        title: _thread.name,
        leadingState: HeaderLeading.MENU,
        iconsAction: _buildHeaderIconsAction(context, _thread.discussionId),
      ),
      sideMenu: MainSideMenu(),
      body: _buildChat(_thread.discussionId),
    );
  }

  Widget _buildChat(int threadId) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(flex: 1, child: _buildMessages(threadId)),
          _buildInputText(threadId),
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

    _chatBloc.getMessages(threadId);

    return StreamBuilder(
        stream: _chatBloc.messages,
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final List<Message> messages = snapshot.data;

          if (messages.length == 0) {
            return Column(children: <Widget>[
                      Text("No messages found"),
                      SizedBox(height: 25.0)
                    ]);
          } else {
            return ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  _scrollToBottom();
                  if (index == 0) {
                    return Column(children: <Widget>[
                      ..._buildBubbleFrame(messages[index], false),
                      SizedBox(height: 25.0)
                    ]);
                  } else {
                    return messages[index].author.id ==
                            messages[index - 1].author.id
                        ? Column(children: <Widget>[
                            ..._buildBubbleFrame(messages[index], true),
                            SizedBox(height: 25.0)
                          ])
                        : Column(children: <Widget>[
                            ..._buildBubbleFrame(messages[index], false),
                            SizedBox(height: 25.0)
                          ]);
                  }
                });
          }
        });
  }

  Widget _buildInputText(int threadId) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      _popupFileSelected,
      Center(
          child: Container(
              padding: EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.blueGrey[700]))),
              child: InputIcon(
                  hintText: "Write a message",
                  customController: _sendController,
                  iconsAction: <IconAction>[
                    IconAction(
                        icon: Icon(Icons.attach_file),
                        action: (String input) {
                          openGallery();
                        }),
                    IconAction(
                        icon: Icon(Icons.camera_alt),
                        action: (String input) {
                          openCamera();
                        }),
                    IconAction(
                        icon: Icon(Icons.send),
                        action: (String input) {
                          _chatBloc.sendChatMessage(
                              input, threadId, _filePicked);
                          _sendController.clear();
                          _filePicked = null;
                        })
                  ])))
    ]));
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
                          message: "Copied in clipboard");
                    }),
                ListTile(
                    title: Text("Remove"),
                    onTap: () {
                      _chatBloc.removeMessage(messageId);
                      Navigator.pop(context);
                      DisplaySnackbar.createConfirmation(
                          message: "Message succesfully Removed");
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

  List<Widget> _buildBubbleFrame(Message message, bool isSameAuthor) {
    if (!isSameAuthor) {
      return <Widget>[
        Row(children: <Widget>[
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(message.author.profilePicture),
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 10.0),
          Text(message.author.username)
        ]),
        Row(children: <Widget>[
          SizedBox(width: 60.0),
          Expanded(
              child: InkWell(
                  onLongPress: () =>
                      _buildModalBottomSheet(message.content, message.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      message.media?.url != null
                          ? Image.network(message.media.url,
                              width: 50.0, height: 50.0)
                          : Container(),
                      Text(message.content)
                    ],
                  )))
        ])
      ];
    } else {
      return <Widget>[
        Row(children: <Widget>[
          SizedBox(width: 60.0),
          Flexible(
              child: InkWell(
                  onLongPress: () =>
                      _buildModalBottomSheet(message.content, message.id),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        message.media?.url != null
                            ? Image.network(message.media.url,
                                width: 50.0, height: 50.0)
                            : Container(),
                        Text(message.content)
                      ])))
        ])
      ];
    }
  }

  Widget _buildFileSelected() {
    return Container(
        width: 200.0,
        height: 50.0,
        child: Row(children: <Widget>[
          Text("Picture selected"),
          IconButton(
            onPressed: () {
              _filePicked = null;
              setState(() {
                _popupFileSelected = Container();
              });
            },
            icon: Icon(Icons.close),
          )
        ]));
  }
}
