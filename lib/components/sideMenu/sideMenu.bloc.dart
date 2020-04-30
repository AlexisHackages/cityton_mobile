import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/screens/chat/chat_service.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:rxdart/rxdart.dart';

class SideMenuBloc {

  final ChatService chatService = ChatService();

  final _threadsFetcher = BehaviorSubject<List<Thread>>.seeded(List<Thread>());
  Stream<List<Thread>> get threads => _threadsFetcher.stream;

  getThreads(int userId) async {
    ApiResponse response = await chatService.getThreads(userId);

    if (response.status == 200) {
      ThreadList threadList = ThreadList.fromJson(response.value);
      _threadsFetcher.sink.add(threadList.threads);
    }
  }

  closeThreads() {
    _threadsFetcher.close();
  }

}