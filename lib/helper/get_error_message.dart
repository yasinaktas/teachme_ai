class GetErrorMessage {
  static String getErrorMessage(int code) {
    switch (code) {
      case 401:
        return "Unauthorized access. Please check your credentials.";
      case 403:
        return "Forbidden access. You do not have permission to perform this action.";
      case 404:
        return "No subtitles found for the given input.";
      case 500:
        return "Server error. Please try again later.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }
}
