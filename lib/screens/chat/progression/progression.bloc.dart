import 'package:cityton_mobile/models/groupProgression.dart';
import 'package:cityton_mobile/shared/services/group.service.dart';

class ProgressionBloc {
  final GroupService groupService = GroupService();

  Future<GroupProgression> getProgression(int threadId) async {
    var response = await groupService.getProgression(threadId);
    print("!!!!! BLOC !!!!!");
    if (response.status == 200) {
      print(response.value);
      print("!!!!! 01 !!!!!");
      print(GroupProgression.fromJson(response.value));
      print("!!!!! 02 !!!!!");
      GroupProgression groupProgression =
          GroupProgression.fromJson(response.value);
      print(groupProgression);
      return groupProgression;
    }
    print("!!!!! END BLOC !!!!!");
    return GroupProgression();
  }
}
