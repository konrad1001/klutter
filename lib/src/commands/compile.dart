import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:Klutter/src/compiler/klutter_compiler.dart';

class CompileCommand extends Command {
  final _compiler = KlutterCompiler();

  @override
  final name = "compile";

  @override
  final description = "Compile a dart file. To be used as a step in build.";

  CompileCommand() {
    argParser.addOption(
      "destination",
      abbr: "d",
      help: "Destination of output file. Defaults to here.",
      defaultsTo: "",
    );
  }

  @override
  FutureOr<dynamic>? run() {
    final sourceFile = argResults?.arguments.first;
    final destination = argResults?.option("destination");

    if (sourceFile == null) {
      throw Exception("Please provide an argument of a valid dart target file");
    }

    try {
      _compile(sourceFile, destination);
    } catch (e) {
      print(e);
    }
  }

  void _compile(String source, String? destination) async {
    await _compiler.compile(source, destination);
  }
}
