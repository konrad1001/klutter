import 'package:mini_flutter_tool/src/device.dart';
import 'package:mini_flutter_tool/src/device_discovery.dart';
import 'package:mini_flutter_tool/src/macos/ios_device.dart';
import 'package:mini_flutter_tool/src/macos/xcode.dart';

class MacosDeviceDiscovery extends DeviceDiscovery {
  final _xcode = Xcode();

  @override
  Future<List<Device>> getAllAvailableDevices() async {
    final results = await Future.wait([
      _getAvailableIOSSimulators(),
      _getAvailableIOSDevices(),
    ]);

    final simulators = results[0] as List<IOSSimulator>;
    final devices = results[1] as List<IOSDevice>;

    return <Device>[
      ...simulators,
      ...devices,
    ];
  }

  Future<List<IOSSimulator>> _getAvailableIOSSimulators() async {
    final allDeviceObjects = await _xcode.getAllSimulators();

    List<IOSSimulator> iosSimulators = [];
    for (final String deviceCategory in allDeviceObjects.keys) {
      if (allDeviceObjects[deviceCategory]
          case final List<Object?> devicesData) {
        for (final Object? data in devicesData) {
          if (data is Map<String, Object?>) {
            final identifier = data["udid"] as String?;
            final name = data["name"] as String?;

            if (identifier == null || name == null) continue;

            final device = IOSSimulator(identifier: identifier, name: name);

            iosSimulators.add(device);
          }
        }
      }
    }

    return iosSimulators;
  }

  Future<List<IOSDevice>> _getAvailableIOSDevices() async {
    final allDeviceObjects = await _xcode.getAllDevices();

    if (allDeviceObjects == null) return [];

    List<IOSDevice> iosDevices = [];
    for (final object in allDeviceObjects) {
      if (object is Map<String, Object?>) {
        if (!_isIPhoneOSDevice(object)) continue;

        final identifier = object['identifier'] as String?;
        final name = object['name'] as String?;

        if (identifier == null || name == null) continue;

        final device = IOSDevice(identifier: identifier, name: name);

        iosDevices.add(device);
      }
    }

    return iosDevices;
  }

  // Only include ios platforms
  bool _isIPhoneOSDevice(Map<String, Object?> deviceProperties) {
    final Object? platform = deviceProperties['platform'];
    if (platform is String) {
      return platform == 'com.apple.platform.iphoneos';
    }
    return false;
  }
}
