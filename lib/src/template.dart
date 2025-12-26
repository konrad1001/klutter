import 'dart:convert';
import 'dart:io';

abstract class Template {
  String get templateDirectory;
  String get targetPrefix;

  Future<int> render(
    Directory directory,
    Map<String, Object?> context,
  ) async {
    final srcDir = Directory(templateDirectory);

    final manifest = File('templates/template_manifest.json');
    final files = (jsonDecode(manifest.readAsStringSync())['files'] as List)
        .cast<String>();

    print(files);

    int written = 0;
    String targetDir = directory.path;
    print(targetDir);

    for (final relativePath in files) {
      final src = File('$templateDirectory/$relativePath');
      final dst = File('$targetDir/$relativePath');

      dst.parent.createSync(recursive: true);

      var contents = src.readAsStringSync();
      context.forEach((k, v) {
        contents = contents.replaceAll('{{$k}}', v.toString());
      });
      dst.writeAsStringSync(contents);

      written++;
    }

    return written;
  }
}

class IOSTemplate extends Template {
  @override
  final templateDirectory = "templates";
  @override
  final targetPrefix = "ios";
}
