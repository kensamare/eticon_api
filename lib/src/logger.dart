import 'dart:developer' as dev;

class Logger {
  static void log(String message, {required String name, bool printMode = false}) {
    if (printMode) {
      print('[$name]: $message');
    } else {
      dev.log(message, name: name);
    }
  }
}
