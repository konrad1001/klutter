import 'package:mini_flutter_tool/src/device.dart';

enum DeviceFilters {
  simOnly;
}

abstract class DeviceDiscovery {
  Future<List<Device>> getAllAvailableDevices({DeviceFilters? filter});
}
