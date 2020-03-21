import 'package:cityton_mobile/blocs/auth_bloc.dart';
import 'package:dio/dio.dart';

class JwtInterceptor extends Interceptor {
  JwtInterceptor();

  @override
  Future onRequest(RequestOptions options) async {
    final authBloc = AuthBloc();

    final String token = await authBloc.getToken();
    print("!!!!! TOKEN !!!!!");
    print(token);
    print("!!!!! END TOKEN !!!!!");

    final customHeaders = {
      'content-type': 'application/json',
      "accept": "application/json",
      'Authorization': 'Bearer $token',
    };

    options.headers.addAll(customHeaders);
    return options;
  }
}
