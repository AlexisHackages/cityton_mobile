import 'package:cityton_mobile/services/chat_service.dart';

class SideMenuBloc {

  final ChatService chatService = new ChatService();

  SideMenuBloc();

  getThreads() async {
    return await chatService.getThreads();
  }

}