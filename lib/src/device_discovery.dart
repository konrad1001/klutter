import 'package:mini_flutter_tool/src/device.dart';

abstract class DeviceDiscovery {
  Future<List<Device>> getAllAvailableDevices();
}
