import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/challenge.dart';
import 'package:cityton_mobile/shared/services/challenge.service.dart';
import 'package:rxdart/rxdart.dart';

class AttributeChallengeBloc {
  final ChallengeService _challengeService = ChallengeService();

  final _challengesFetcher =
      BehaviorSubject<List<Challenge>>.seeded(List<Challenge>());
  Stream<List<Challenge>> get challenges => _challengesFetcher.stream;

  closeChallengesStream() {
    _challengesFetcher.close();
  }

  Future<void> search(String searchText, int threadId) async {

    String sanitizedSearchText = searchText.trim();

    var response = await _challengeService.searchProgression(sanitizedSearchText, threadId);
    
    ChallengeList challengeAdminList = ChallengeList.fromJson(response.value);

    List<Challenge> challenges = challengeAdminList.challenges;

    _challengesFetcher.sink.add(challenges);
  }

  Future<ApiResponse> attributeToGroup(int threadId, List<int> selectedChallenges) async {
      var response = await _challengeService.attributeToGroup(threadId, selectedChallenges);

      return response;
  }
}
