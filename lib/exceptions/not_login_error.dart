class NotLoginErrorException {
  final String message;

  NotLoginErrorException([this.message = "There is no user logged in"]);
}
