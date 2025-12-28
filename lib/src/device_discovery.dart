import 'package:Klutter/src/device.dart';

enum DeviceFilters { simOnly }

abstract class DeviceDiscovery {
  Future<List<Device>> getAllAvailableDevices({DeviceFilters? filter});
}
