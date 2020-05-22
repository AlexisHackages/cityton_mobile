import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/groupMinimal.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';
import 'package:rxdart/rxdart.dart';

class GroupManagementBloc {
  final GroupService _groupService = GroupService();

  final _groupFetcher =
      BehaviorSubject<List<GroupMinimal>>.seeded(List<GroupMinimal>());
  Stream<List<GroupMinimal>> get groups => _groupFetcher.stream;

  closeGroupStream() {
    _groupFetcher.close();
  }

  Future<void> search(String searchText, int selectedFilter) async {
    String sanitizedSearchText = searchText.trim();

    var response = await _groupService.search(sanitizedSearchText, selectedFilter);
    
    GroupMinimalList groupsList = GroupMinimalList.fromJson(response.value);

    List<GroupMinimal> groups = groupsList.groups;

    _groupFetcher.sink.add(groups);
  }
  
  Future<ApiResponse> delete(int id) async {

    var response = await _groupService.delete(id);

    return response;
  }
}
