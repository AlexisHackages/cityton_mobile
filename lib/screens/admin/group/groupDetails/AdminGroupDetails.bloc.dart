import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';
import 'package:rxdart/rxdart.dart';

class AdminGroupDetailsBloc {
  final GroupService _groupService = GroupService();
  final UserService _userService = UserService();

  final _groupInfoFetcher = BehaviorSubject<Group>.seeded(null);
  Stream<Group> get groupInfo => _groupInfoFetcher.stream;

  getGroupInfo(int groupId) async {
    final response = await _groupService.getGroupInfo(groupId);

    if (response.status == 200) {
      Group groupInfo = Group.fromJson(response.value);
      _groupInfoFetcher.sink.add(groupInfo);
    }
  }

  Future<ApiResponse> delete(int id) async {
    var response = await _groupService.delete(id);

    return response;
  }

  Future<ApiResponse> getAllStaffMember() {
    var response = _userService.getAllStaffMember();

    return response;
  }

  Future<ApiResponse> attributeSupervisor(int groupId, int selectedUserId) {
    var response = _groupService.attributeSupervisor(groupId, selectedUserId);

    return response;
  }

  closeGroupInfo() {
    _groupInfoFetcher.close();
  }
}
