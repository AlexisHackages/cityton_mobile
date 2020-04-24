import 'package:cityton_mobile/models/challengeAdmin.dart';
import 'package:cityton_mobile/shared/services/challenge.service.dart';
import 'package:rxdart/rxdart.dart';

class AdminChallengeBloc {
  final ChallengeService challengeService = ChallengeService();

  final _challengesFetcher =
      BehaviorSubject<List<ChallengeAdmin>>.seeded(List<ChallengeAdmin>());
  Stream<List<ChallengeAdmin>> get challenges => _challengesFetcher.stream;

  Future<void> search(String searchText, DateTime selectedDate) async {

    String sanitizedsearchText = searchText.trim();

    var response = await challengeService.search(sanitizedsearchText, selectedDate);
    
    ChallengeAdminList challengeAdminList = ChallengeAdminList.fromJson(response.value);

    List<ChallengeAdmin> challenges = challengeAdminList.challenges;

    _challengesFetcher.sink.add(challenges);
  }

  closeChallengeStream() {
    _challengesFetcher.close();
  }
}
