class ApiResponse {
  final int status;
  final dynamic value;

  ApiResponse(this.status, this.value);
}

// class OkResult extends ApiResponse {
//   final int status;
//   final dynamic data;

//   OkResult(this.status, this.data) : super(status, value);
// }