import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:Klutter/src/macos/macos_device_discovery.dart';
import 'package:Klutter/src/macos/xcode.dart';

class DevicesCommand extends Command {
  final _discoverer = MacosDeviceDiscovery();

  @override
  final name = "devices";

  @override
  final description = "List available devices (ios)";

  DevicesCommand() {
    argParser.addFlag(
      "real",
      abbr: "r",
      help:
          "Whether to search for real devices as well as simulators (defaults to false)",
      defaultsTo: false,
      negatable: false,
    );
  }

  @override
  FutureOr<dynamic>? run() {
    final simOnly = !(argResults?.flag("real") ?? false);

    _devices(simOnly);
  }

  void _devices(bool simOnly) async {
    print("Searching for devices");
    final result = await _discoverer.getAllAvailableDevices(
      filter: simOnly ? .simOnly : null,
    );

    print(result);
  }
}
