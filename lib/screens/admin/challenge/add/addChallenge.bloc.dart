import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/challenge.service.dart';

class AddChallengeBloc {
  final ChallengeService _challengeService = ChallengeService();

  Future<ApiResponse> add(String title, String statement) async {

    String sanitizedtitle = title.trim();
    String sanitizedstatement = statement.trim();

    var response = await _challengeService.add(sanitizedtitle, sanitizedstatement);

    return response;
  }
}
