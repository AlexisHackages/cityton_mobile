import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/challenge.service.dart';

class EditChallengeBloc {
  final ChallengeService challengeService = ChallengeService();
  
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
