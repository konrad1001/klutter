import 'dart:io';

abstract class Environment {
  static String? root = Platform.environment['KLUTTER_ROOT'];
}
