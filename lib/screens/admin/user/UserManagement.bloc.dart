import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/userProfile.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';
import 'package:rxdart/rxdart.dart';

class UserManagementBloc {
  final UserService userService = UserService();

  final _userProfilesFetcher =
      BehaviorSubject<List<UserProfile>>.seeded(List<UserProfile>());
  Stream<List<UserProfile>> get userProfiles => _userProfilesFetcher.stream;

  closeChallengeStream() {
    _userProfilesFetcher.close();
  }

  Future<void> search(String searchText, int selectedRole) async {
    String sanitizedsearchText = searchText.trim();

    var response = await userService.search(sanitizedsearchText, selectedRole == -1 ? null : selectedRole);
    
    UserProfileList userProfileList = UserProfileList.fromJson(response.value);

    List<UserProfile> userProfiles = userProfileList.userProfiles;

    _userProfilesFetcher.sink.add(userProfiles);
  }
  
  Future<ApiResponse> delete(int id) async {

    var response = await userService.delete(id);

    return response;
  }
}
