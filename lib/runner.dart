import 'package:args/command_runner.dart';
import 'package:mini_flutter_tool/src/commands/create.dart';
import 'package:mini_flutter_tool/src/commands/test.dart';

final runner =
    CommandRunner("klutter", "A very small cross platform compiler for dart.")
      ..addCommand(TestCommand())
      ..addCommand(CreateCommand());
