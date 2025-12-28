import 'dart:convert';
import 'dart:io';

import 'package:Klutter/src/environment.dart';

class Template {
  final templateDirectory = "templates";

  Future<int> render(Directory directory, Map<String, Object?> context) async {
    final root = Environment.root;

    if (root == null) {
      throw StateError("Klutter root not set!");
    }

    final manifest = File('$root/templates/template_manifest.json');
    final files = (jsonDecode(manifest.readAsStringSync())['files'] as List)
        .cast<String>();

    int written = 0;
    String targetDir = directory.path;

    for (var relativePath in files) {
      final src = File('$root/$templateDirectory/$relativePath');

      if (relativePath.endsWith(".templ")) {
        relativePath = relativePath.substring(0, relativePath.length - 6);
      }
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
