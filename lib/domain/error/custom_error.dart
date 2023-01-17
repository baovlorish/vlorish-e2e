enum CustomExceptionType { Error, Success, Inform }

class CustomException implements Exception {
  final String message;
  final CustomExceptionType type;

  CustomException(
    this.message, {
    this.type = CustomExceptionType.Error,
  });

  @override
  String toString() {
    return message;
  }
}
