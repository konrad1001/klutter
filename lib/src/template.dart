import 'dart:io';

abstract class Template {
  String get templateDirectory;
  String get targetPrefix;

  Future<int> render(
    Directory directory,
    Map<String, Object?> context,
  ) async {
    final srcDir = Directory(templateDirectory);

    await for (var entity in srcDir.list(recursive: true, followLinks: false)) {
      print(entity.path);
    }

    return 0;
  }
}

class IOSTemplate extends Template {
  @override
  final templateDirectory = "templates/ios";
  @override
  final targetPrefix = "ios";
}
