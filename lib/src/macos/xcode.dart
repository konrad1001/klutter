// Util for interacting with xcode on macos.

import 'dart:convert';
import 'dart:io';

class Xcode {
  Future<void> build({
    required String destination,
    required String workingDirectory,
  }) async {
    final result = await Process.run("xcodebuild", [
      "-project",
      "Runner.xcodeproj",
      "-scheme",
      "Runner",
      "-destination",
      "platform=iOS Simulator,name=iPhone 17",
      "-derivedDataPath",
      "build/ios",
      "build",
    ], workingDirectory: workingDirectory);

    if (result.exitCode != 0) {
      print(result.stderr);
    }

    print(result.stdout);
  }

  Future<Map<String, Object?>> getAllSimulators() async {
    final result = await Process.run("xcrun", [
      "simctl",
      "list",
      "devices",
      "booted",
      "iOS",
      "--json",
    ]);

    if (result.exitCode == 0) {
      final stdout = result.stdout;
      try {
        final Object? decodeResult =
            (json.decode(stdout) as Map<String, Object?>)['devices'];
        if (decodeResult is Map<String, Object?>) {
          return decodeResult;
        }
        print("Received unexpected result from xcrun");
      } catch (e) {
        print("xcrun list simulators error $e");
        return {};
      }
    }
    return {};
  }

  Future<List<Object>?> getAllDevices() async {
    final result = await Process.run("xcrun", ["xcdevice", "list"]);

    if (result.exitCode == 0) {
      final stdout = result.stdout;
      try {
        final listResult = (json.decode(stdout) as List<Object?>)
            .whereType<Object>()
            .toList();
        return listResult;
      } catch (e) {
        print("xcdevice list devices error $e");
      }
    }
    return null;
  }
}
