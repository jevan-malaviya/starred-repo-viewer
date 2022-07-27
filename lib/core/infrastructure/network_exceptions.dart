class RestApiExceptions implements Exception {
  final int? errorCode;

  RestApiExceptions(this.errorCode);
}
