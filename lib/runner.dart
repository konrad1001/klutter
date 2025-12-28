import 'package:Klutter/src/commands/compile.dart';
import 'package:args/command_runner.dart';
import 'package:Klutter/src/commands/create.dart';
import 'package:Klutter/src/commands/devices.dart';
import 'package:Klutter/src/commands/build.dart';
import 'package:Klutter/src/commands/run.dart';

final runner = CommandRunner("klutter", "A very small ios compiler for dart.")
  ..addCommand(BuildCommand())
  ..addCommand(RunCommand())
  ..addCommand(DevicesCommand())
  ..addCommand(CompileCommand())
  ..addCommand(CreateCommand());
