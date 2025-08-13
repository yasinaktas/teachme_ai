class UnknownErrorException implements Exception {
  final String message;

  UnknownErrorException([this.message = "An unknown error occurred."]);
}
