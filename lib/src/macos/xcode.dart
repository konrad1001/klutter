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
      "platform=iOS Simulator,name=$destination",
      "-derivedDataPath",
      "build",
      "build",
    ], workingDirectory: workingDirectory);

    if (result.exitCode != 0) {
      throw Exception("Error building project ${result.stderr}");
    }
  }

  Future<void> install({
    required String destination,
    required String workingDirectory,
  }) async {
    final result = await Process.run("xcrun", [
      "simctl",
      "install",
      "booted",
      destination,
    ], workingDirectory: workingDirectory);

    if (result.exitCode != 0) {
      throw Exception("Error installing project ${result.stderr}");
    }

    print(result.stdout);
  }

  Future<void> launch({
    required String bundleId,
    required String workingDirectory,
  }) async {
    final result = await Process.run("xcrun", [
      "simctl",
      "launch",
      "booted",
      bundleId,
    ], workingDirectory: workingDirectory);

    if (result.exitCode != 0) {
      throw Exception("Error launching project ${result.stderr}");
    }
  }

  Future<void> bootSimulator({
    required String id,
    required String workingDirectory,
    bool withOpen = true,
  }) async {
    final result = await Process.run("xcrun", [
      "simctl",
      "boot",
      id,
    ], workingDirectory: workingDirectory);

    if (result.exitCode != 0) {
      if (result.exitCode == 149) {
        // Device is already booted.
      } else {
        print(result.stderr);
      }
    }

    if (withOpen) {
      Process.run("open", ["-a", "Simulator"]);
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

  Future<String?> getBundleIdentifier({
    required String workingDirectory,
  }) async {
    final result = await Process.run('xcodebuild', [
      '-project',
      'Runner.xcodeproj',
      '-scheme',
      'Runner',
      '-showBuildSettings',
    ], workingDirectory: workingDirectory);

    if (result.exitCode != 0) {
      print(result.stderr);
      return null;
    }

    final output = result.stdout as String;
    final match = RegExp(
      r'^\s*PRODUCT_BUNDLE_IDENTIFIER = (.+)$',
      multiLine: true,
    ).firstMatch(output);
    return match?.group(1)?.trim();
  }
}
