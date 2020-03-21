import 'package:dio/dio.dart';
import 'package:cityton_mobile/http/jwt_interceptor.dart';
import 'package:cityton_mobile/blocs/auth_bloc.dart';

class Http {
  static final Http _instance = Http._internal();
  Dio _dio;
  BaseOptions _options;
  final String baseUrl = "http://10.0.2.2:5000/api";

  static final authBloc = AuthBloc();

  factory Http() {
    return _instance;
  }

  Http._internal() {
    authBloc.getToken().then((String token) {
      _options = BaseOptions(baseUrl: baseUrl, headers: {
        'content-type': 'application/json',
        'accept': "application/json",
        'Authorization': 'Bearer $token',
      });

      _dio = Dio(_options);

      _dio.interceptors.add(JwtInterceptor());
    });
  }

  Future get(String url, [Map<String, dynamic> params]) {
    return _dio.get(url, queryParameters: params == null ? {} : params);
  }

  Future post(String url, [Map<String, dynamic> params]) {
    return _dio.post(url, data: params == null ? {} : params);
  }
}
