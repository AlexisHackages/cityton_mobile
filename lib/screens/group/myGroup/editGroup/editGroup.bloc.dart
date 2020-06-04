import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';

class EditGroupBloc {
  final GroupService _groupService = GroupService();
  
  Future<ApiResponse> editName(String name, int groupId) async {

    var response = await _groupService.editName(name, groupId);

    return response;
  }
}
