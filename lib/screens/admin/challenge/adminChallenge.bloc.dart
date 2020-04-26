import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/challengeAdmin.dart';
import 'package:cityton_mobile/shared/services/challenge.service.dart';
import 'package:rxdart/rxdart.dart';

class AdminChallengeBloc {
  final ChallengeService challengeService = ChallengeService();

  final _challengesFetcher =
      BehaviorSubject<List<ChallengeAdmin>>.seeded(List<ChallengeAdmin>());
  Stream<List<ChallengeAdmin>> get challenges => _challengesFetcher.stream;

  closeChallengeStream() {
    _challengesFetcher.close();
  }

  Future<void> search(String searchText, DateTime selectedDate) async {

    String sanitizedsearchText = searchText.trim();

    var response = await challengeService.search(sanitizedsearchText, selectedDate);
    
    ChallengeAdminList challengeAdminList = ChallengeAdminList.fromJson(response.value);

    List<ChallengeAdmin> challenges = challengeAdminList.challenges;

    _challengesFetcher.sink.add(challenges);
  }

  Future<ApiResponse> add(String title, String statement) async {

    String sanitizedtitle = title.trim();
    String sanitizedstatement = statement.trim();

    var response = await challengeService.add(sanitizedtitle, sanitizedstatement);

    return response;
  }
  
  Future<ApiResponse> edit(int id, String title, String statement) async {

    String sanitizedtitle = title.trim();
    String sanitizedstatement = statement.trim();

    var response = await challengeService.edit(id, sanitizedtitle, sanitizedstatement);

    return response;
  }
  
  Future<ApiResponse> delete(int id) async {

    var response = await challengeService.delete(id);

    return response;
  }
}
