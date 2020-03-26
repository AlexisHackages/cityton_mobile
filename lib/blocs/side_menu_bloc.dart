import 'package:cityton_mobile/services/chat_service.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:rxdart/rxdart.dart';

class SideMenuBloc {

  final ChatService chatService = ChatService();

  final _threadsFetcher = BehaviorSubject<List<Thread>>.seeded(List<Thread>());
  Stream<List<Thread>> get threads => _threadsFetcher.stream;

  SideMenuBloc();

  getThreads() async {
    List<Thread> threads = await chatService.getThreads();
    _threadsFetcher.sink.add(threads);
  }

  closeThreads() {
    _threadsFetcher.close();
  }

}