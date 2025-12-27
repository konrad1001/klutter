import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mini_flutter_tool/src/macos/macos_device_discovery.dart';
import 'package:mini_flutter_tool/src/macos/xcode.dart';

class DevicesCommand extends Command {
  final _discoverer = MacosDeviceDiscovery();

  @override
  final name = "devices";

  @override
  final description = "List available devices (ios)";

  @override
  FutureOr<dynamic>? run() {
    _devices();
  }

  void _devices() async {
    print("Searching for devices");
    final result = await _discoverer.getAllAvailableDevices();

    print(result);
  }
}
