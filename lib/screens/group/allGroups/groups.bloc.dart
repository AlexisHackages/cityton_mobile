import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/groupMinimal.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';
import 'package:rxdart/rxdart.dart';

class GroupsBloc {
  final GroupService _groupService = GroupService();
  final UserService _userService = UserService();
  final AuthBloc _authBloc = AuthBloc();

  final _groupsFetcher =
      BehaviorSubject<List<GroupMinimal>>.seeded(List<GroupMinimal>());
  Stream<List<GroupMinimal>> get groups => _groupsFetcher.stream;

  closeGroupStream() {
    _groupsFetcher.close();
  }

  Future<void> search(String groupName, int selectedFilter) async {
    String sanitizedGroupName = groupName.trim();

    var response =
        await _groupService.search(sanitizedGroupName, selectedFilter);

    if (response.status == 200) {
      GroupMinimalList groupList = GroupMinimalList.fromJson(response.value);

      List<GroupMinimal> groups = groupList.groups;

      _groupsFetcher.sink.add(groups);
    }
  }

  Future<ApiResponse> createRequest(int id) async {
    var response = await _groupService.createRequest(id);

    return response;
  }

  Future<ApiResponse> refreshCurrentUser() async {
    var response = await _userService.getCurrentUser();

    if (response.status == 200) {
      User currentUser = User.fromJson(response.value);
      _authBloc.writeCurrentUser(currentUser);
    } else {
      _authBloc.deleteCurrentUser();
    }

    return response;
  }
}
