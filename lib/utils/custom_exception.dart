class CustomException implements Exception {
  dynamic message;
  CustomException(this.message);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}
