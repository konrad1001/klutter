import 'dart:convert';
import 'dart:io';

class KlutterCompiler {
  Future<File> compile(String sourcePath, String? destinationPath) async {
    final source = await _validateAndRead(sourcePath);
    final variableMap = _parseVariables(source);

    final compiledJson = jsonEncode(variableMap);

    var filePath = "app.json";
    if (destinationPath != null) {
      filePath = "$destinationPath/$filePath";
    }

    final file = File(filePath);
    return file.writeAsString(compiledJson);
  }

  Future<String> _validateAndRead(String source) async {
    return await File(source).readAsString();
  }

  Map<String, String> _parseVariables(String source) {
    Map<String, String> map = {};

    final appColour = RegExp(
      r"""^\s*String appColour = ["\'](.+?)["\'];$""",
      multiLine: true,
    ).firstMatch(source)?.group(1)?.trim();

    if (appColour != null) {
      map["backgroundColour"] = appColour;
    } else {
      map["backgroundColour"] = "#FFFFFF";
    }

    return map;
  }
}
