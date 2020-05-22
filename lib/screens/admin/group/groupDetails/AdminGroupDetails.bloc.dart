import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';

class AdminGroupDetailsBloc {
  final GroupService _groupService = GroupService();

  Future<ApiResponse> getGroupInfo(int groupId) async {
    final response = await _groupService.getGroupInfo(groupId);

    return response;
  }

  Future<ApiResponse> delete(int id) async {
    var response = await _groupService.delete(id);

    return response;
  }
}
