import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:Klutter/src/macos/xcode.dart';

class BuildCommand extends Command {
  final _xcode = Xcode();

  @override
  final name = "build";

  @override
  final description = "Build an existing Klutter project";

  @override
  FutureOr<dynamic>? run() {
    try {
      _build();
    } catch (e) {
      print(e);
    }
  }

  void _build() async {
    print("Attempting to build project");

    // Check for pubspec
    if (!_pubspecExists(Directory.current)) {
      throw Exception(
        "No pubspec.yaml found! This may not be a klutter repository.",
      );
    }

    // Check for main.dart
    if (!_mainExists(Directory.current)) {
      throw Exception(
        "No main.dart found! This may not be a klutter repository.",
      );
    }

    final iosDir = Directory("ios");
    final runnerDir = Directory("ios/Runner");

    // Build project
    final compile = await Process.run("klutter", [
      "compile",
      "lib/main.dart",
      "-d",
      runnerDir.path,
    ]);

    // Build xcode
    await _xcode.build(destination: "iPhone 17", workingDirectory: iosDir.path);

    print("Successfully built project");
  }

  bool _pubspecExists(Directory projectDir) {
    final file = File('${projectDir.path}/pubspec.yaml');
    return file.existsSync();
  }

  bool _mainExists(Directory projectDir) {
    final file = File('${projectDir.path}/lib/main.dart');
    return file.existsSync();
  }
}
