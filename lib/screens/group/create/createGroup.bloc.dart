import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';

class CreateGroupBloc {
  final GroupService _groupService = GroupService();

  Future<ApiResponse> add(String name) async {

    String sanitizedName = name.trim();

    var response = await _groupService.add(sanitizedName);

    return response;
  }
}
