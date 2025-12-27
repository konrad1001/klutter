import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mini_flutter_tool/src/macos/macos_device_discovery.dart';
import 'package:mini_flutter_tool/src/macos/xcode.dart';

class RunCommand extends Command {
  final _xcode = Xcode();
  final _discoverer = MacosDeviceDiscovery();

  @override
  final name = "run";

  @override
  final description = "Run a Klutter project";

  @override
  FutureOr<dynamic>? run() {
    try {
      _run();
    } catch (e) {
      print(e);
    }
  }

  void _run() async {
    print("Attempting to run project");
    final iosDir = Directory("ios").path;

    // Check project is built
    final appBuild = _buildExists(Directory.current);
    if (appBuild == null) {
      throw Exception("No Runner.app found. Try building the project first");
    }

    // Get bundle identifier
    final bundleId = await _xcode.getBundleIdentifier(workingDirectory: iosDir);
    if (bundleId == null) {
      throw Exception("No bundle id found");
    }

    final devices = await _discoverer.getAllAvailableDevices(filter: .simOnly);
    if (devices.isEmpty) return;

    final chosenDevice = devices.first;

    // Boot device
    await _xcode.bootSimulator(
      id: chosenDevice.identifier,
      workingDirectory: iosDir,
    );

    // Install to device
    await _xcode.install(destination: appBuild.path, workingDirectory: iosDir);

    // Launch
    await _xcode.launch(bundleId: bundleId, workingDirectory: iosDir);

    print("Successfully started project on ${chosenDevice.name}");
  }

  Directory? _buildExists(Directory projectDir) {
    final file = Directory(
      '${projectDir.path}/ios/build/ios/Build/Products/Debug-iphonesimulator/Runner.app',
    );
    if (file.existsSync()) {
      return file;
    } else {
      return null;
    }
  }
}
