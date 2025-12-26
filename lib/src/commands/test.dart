import 'dart:async';

import 'package:args/command_runner.dart';

class TestCommand extends Command {
  @override
  final name = "test";

  @override
  final description = "A test command";

  @override
  FutureOr<dynamic>? run() {
    print("Running test args: ${argParser}");
  }
}
