import 'package:args/command_runner.dart';
import 'package:mini_flutter_tool/src/commands/create.dart';
import 'package:mini_flutter_tool/src/commands/devices.dart';
import 'package:mini_flutter_tool/src/commands/build.dart';
import 'package:mini_flutter_tool/src/commands/run.dart';

final runner = CommandRunner("klutter", "A very small ios compiler for dart.")
  ..addCommand(BuildCommand())
  ..addCommand(RunCommand())
  ..addCommand(DevicesCommand())
  ..addCommand(CreateCommand());
