import 'dart:io';

const compiledJson = """
{
  "backgroundColor": "#FF14A0"
}
""";

class KlutterCompiler {
  Future<File> compile({required String source, String? destination}) async {
    var filePath = "app.json";
    if (destination != null) {
      filePath = "$destination/$filePath";
    }

    final file = File(filePath);
    return file.writeAsString(compiledJson);
  }
}
