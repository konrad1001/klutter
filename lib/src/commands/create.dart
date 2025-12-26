import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mini_flutter_tool/src/template.dart';

class CreateCommand extends Command {
  @override
  final name = "create";

  @override
  final description = "Create a new klutter project";

  CreateCommand() {
    argParser.addOption("project-name", help: "Set the project name");
  }

  @override
  FutureOr<dynamic>? run() {
    final projectName = argResults?.option("project-name") ?? "new-project";

    _create(projectName);
  }

  void _create(String projectName) {
    final targetDir = Directory(projectName);

    targetDir.create(recursive: true);

    IOSTemplate().render(targetDir, {});
  }
}
