import 'package:cityton_mobile/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {

  final AuthService authService = AuthService();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final _tokenFetcher = BehaviorSubject<String>.seeded(null);
  Stream<String> get token => _tokenFetcher.stream;

  AuthBloc();

  Future<bool> login(String email, String password) async {
    await storage.deleteAll();
    String token = await authService.login(email, password);
    await storage.write(key: "token", value: token);

    _tokenFetcher.sink.add(token);

    return true;
  }

  void logout() {
    storage.delete(key: "token");
  }

  Future<String> getToken() async {
    return await storage.read(key: "token");
  }

  void closeTokenStream() {
    _tokenFetcher.close();
  }

}