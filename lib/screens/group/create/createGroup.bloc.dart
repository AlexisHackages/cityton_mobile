import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';

class CreateGroupBloc {
  final GroupService groupService = GroupService();

  Future<ApiResponse> add(String name) async {

    String sanitizedName = name.trim();

    var response = await groupService.add(sanitizedName);

    return response;
  }
}
