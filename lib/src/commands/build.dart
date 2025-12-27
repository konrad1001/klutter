import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mini_flutter_tool/src/macos/xcode.dart';

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
      throw Exception("Invalid repository for build");
    }

    final iosDir = Directory("ios");

    await _xcode.build(destination: "iPhone17", workingDirectory: iosDir.path);

    print("Successfully built project");
  }

  bool _pubspecExists(Directory projectDir) {
    final file = File('${projectDir.path}/pubspec.yaml');
    return file.existsSync();
  }
}
