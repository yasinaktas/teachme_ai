class AccessTokenErrorException {
  final String message;

  AccessTokenErrorException([
    this.message = "Access token is invalid or expired",
  ]);
}
