// Custom exception class to handle errors in the app
class GoGoException implements Exception {
  String message;
  GoGoException(this.message);
}
