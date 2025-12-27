import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mini_flutter_tool/src/template.dart';

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
    final projectName = argResults?.option("project-name") ?? "new-project";

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
      "Finished creating a klutter project for. Wrote $filesWritten files.",
    );
  }
}
