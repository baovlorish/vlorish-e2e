import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: CustomLogPrinter(className));
}

class CustomLogPrinter extends LogPrinter {
  final String className;

  CustomLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    if (event.message.length > 1024) {
      printWrapped(event.message);
      return ['--------------------------------------'];
    } else {
      var emoji = PrettyPrinter.levelEmojis[event.level]!;
      var color = PrettyPrinter.levelColors[event.level];
      return [
        '$color($emoji [$className] ${PrettyPrinter.singleDivider} ${event.message})'
      ];
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    //ignore: avoid_print
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
