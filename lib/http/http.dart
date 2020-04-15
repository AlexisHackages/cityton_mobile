import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Http {
  static final Http _instance = Http._internal();
  Dio _dio;
  BaseOptions _options;

  static final authBloc = AuthBloc();

  factory Http() {
    return _instance;
  }

  Http._internal() {
    _options = BaseOptions(
      baseUrl: DotEnv().env['API_URL'],
      headers: {
        'content-type': 'application/json',
        'accept': "application/json",
      },
      followRedirects: false,
      validateStatus: (status) { return status < 500; },
    );
    
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
