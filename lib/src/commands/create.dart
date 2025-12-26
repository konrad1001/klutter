import 'dart:async';

import 'package:args/command_runner.dart';

class CreateCommand extends Command {
  @override
  final name = "create";

  @override
  final description = "Create a new klutter project";

  @override
  FutureOr<dynamic>? run() {
    print("Running create args: ${argParser}");
  }
}
