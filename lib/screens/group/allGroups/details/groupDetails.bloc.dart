import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/group.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';
import 'package:rxdart/rxdart.dart';

class GroupDetailsBloc {
  final GroupService groupService = GroupService();

  final _groupDetailsFetcher =
      BehaviorSubject<Group>.seeded(Group());
  Stream<Group> get groupDetails => _groupDetailsFetcher.stream;

  closeChallengeStream() {
    _groupDetailsFetcher.close();
  }

  Future<ApiResponse> getGroupInfo(int groupId) async {

    final response = await groupService.getGroupInfo(groupId);

    if (response.status == 200) {
      Group group = Group.fromJson(response.value);
      _groupDetailsFetcher.sink.add(group);
    }

    return response;
  }
  
  Future<ApiResponse> delete(int id) async {

    var response = await groupService.delete(id);

    return response;
  }
  
  Future<ApiResponse> createRequest(int id) async {

    var response = await groupService.createRequest(id);

    return response;
  }
}
