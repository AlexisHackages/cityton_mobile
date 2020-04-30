// import 'package:cityton_mobile/screens/chat/chat_service.dart';
// import 'package:cityton_mobile/models/thread.dart';
// import 'package:rxdart/rxdart.dart';

// class ThreadsListBloc {

//   final ChatService chatService = ChatService();

//   final _threadsFetcher = BehaviorSubject<List<Thread>>.seeded(List<Thread>());
//   Stream<List<Thread>> get threads => _threadsFetcher.stream;

//   ThreadsListBloc();

//   getThreads() async {
//     List<Thread> threads = await chatService.getThreads();
//     _threadsFetcher.sink.add(threads);
//   }

//   closeThreads() {
//     _threadsFetcher.close();
//   }

// }