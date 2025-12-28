import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:Klutter/src/template.dart';

class CreateCommand extends Command {
  @override
  final name = "create";

  @override
  final description = "Create a new Klutter project";

  CreateCommand() {
    argParser.addOption("project-name", help: "Set the project name");
  }

  @override
  FutureOr<dynamic>? run() {
    final projectName = argResults?.option("project-name") ?? "sandboxproj";

    _create(projectName);
  }

  void _create(String projectName) async {
    final targetDir = Directory(projectName);

    targetDir.create(recursive: true);

    final filesWritten = await Template().render(targetDir, {
      "PROJECT_NAME": projectName,
      "BUNDLE_IDENTIFIER": projectName,
    });

    print(
      "Finished creating a new klutter project. Wrote $filesWritten files.",
    );
  }
}
