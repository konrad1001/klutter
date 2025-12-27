abstract class Device {
  final String identifier;
  final String name;

  Device({required this.identifier, required this.name});

  @override
  String toString() {
    return "$name $identifier";
  }
}
