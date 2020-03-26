import 'package:dio/dio.dart';
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
    _options = BaseOptions(baseUrl: baseUrl, headers: {
      'content-type': 'application/json',
      'accept': "application/json",
    });
    
    _dio = Dio(_options);
    
    _dio.interceptors
        .add(InterceptorsWrapper(
          onRequest: (RequestOptions options) async {
            
            _dio.interceptors.requestLock.lock();
            String token = await authBloc.getToken();
            
            if (token != null) {
              options.headers["Authorization"] = "Bearer " + token;
            }
            
            _dio.interceptors.requestLock.unlock();
            return options;
          }
        ));
  }

  Future get(String url, [Map<String, dynamic> params]) {
    return _dio.get(url, queryParameters: params == null ? {} : params);
  }

  Future post(String url, [Map<String, dynamic> params]) {
    return _dio.post(url, data: params == null ? {} : params);
  }
}
