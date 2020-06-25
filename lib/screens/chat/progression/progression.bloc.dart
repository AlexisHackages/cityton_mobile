import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/groupProgression.dart';
import 'package:cityton_mobile/shared/services/challenge.service.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';
import 'package:rxdart/rxdart.dart';

class ProgressionBloc {
  final GroupService _groupService = GroupService();
  final ChallengeService _challengeService = ChallengeService();

  final _groupProgressionFetcher =
      BehaviorSubject<GroupProgression>.seeded(null);
  Stream<GroupProgression> get groupProgression => _groupProgressionFetcher.stream;

  Future<ApiResponse> getProgression(int threadId) async {
    var response = await _groupService.getProgression(threadId);
    
    if (response.status == 200) {
      GroupProgression groupProgression =
          GroupProgression.fromJson(response.value);
      _groupProgressionFetcher.sink.add(groupProgression);

      return response;
    }

    return response;
  }

  closeGroupProgression() {
    _groupProgressionFetcher.close();
  }

  Future<ApiResponse> validate(int challengeId, int threadId) async {
    var response = await _challengeService.validate(challengeId);

    if (response.status == 200) {
      return getProgression(threadId);
    }
    
    return response;
  }

  Future<ApiResponse> reject(int challengeId, int threadId) async {
    var response = await _challengeService.reject(challengeId);

    if (response.status == 200) {
      return getProgression(threadId);
    }
    
    return response;
  }

  Future<ApiResponse> undo(int challengeId, int threadId) async {
    var response = await _challengeService.undo(challengeId);

    if (response.status == 200) {
      return getProgression(threadId);
    }
    
    return response;
  }
}
