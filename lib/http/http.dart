import 'package:cityton_mobile/http/ApiResponse.dart';
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

  Dio getDioClient(){
    return _dio;
  }

  Http._internal() {
    _options = BaseOptions(
      baseUrl: DotEnv().env['API_URL'],
      // headers: {
      //   'content-type': 'application/json',
      //   'accept': "application/json",
      // },
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
    );

    _dio = Dio(_options);

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      _dio.interceptors.requestLock.lock();
      String token = await authBloc.getToken();

      if (token != null) {
        options.headers["Authorization"] = "Bearer " + token;
      }

      _dio.interceptors.requestLock.unlock();
      return options;
    }));
  }

  Future<ApiResponse> get(String url, [Map<String, dynamic> params]) async {
    final requestResponse = await _dio.get(url, queryParameters: params == null ? {} : params);
    return _returnResponse(requestResponse);
  }

  Future<ApiResponse> post(String url, {dynamic data, Map<String, dynamic> queryParameters, void Function(int, int) onSendProgress}) async {
    final requestResponse = await _dio.post(
      url,
      data: data == null ? {} : data,
      queryParameters: queryParameters == null ? {} : queryParameters,
      onSendProgress: onSendProgress);
    return _returnResponse(requestResponse);
  }

  Future<ApiResponse> delete(String url, [Map<String, dynamic> params]) async {
    final requestResponse = await _dio.delete(url, queryParameters: params == null ? {} : params);
    return _returnResponse(requestResponse);
  }

  Future<ApiResponse> put(String url, {dynamic data, Map<String, dynamic> queryParameters, void Function(int, int) onSendProgress}) async {
    final requestResponse = await _dio.put(
      url,
      data: data == null ? {} : data,
      queryParameters: queryParameters == null ? {} : queryParameters,
      onSendProgress: onSendProgress);
    return _returnResponse(requestResponse);
  }

  ApiResponse _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return ApiResponse(response.statusCode, response.data);
      case 400:
        return ApiResponse(response.statusCode, response.data);
      case 404:
        return ApiResponse(response.statusCode, response.data);
      case 500:
      default:
        return ApiResponse(response.statusCode, 
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
