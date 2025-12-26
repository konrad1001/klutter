import 'package:mini_flutter_tool/runner.dart';

Future<void> main(List<String> args) async {
  try {
    await runner.run(args);
  } catch (e) {
    print("Error running klutter!");
    print(
        "Run 'klutter -h' (or 'klutter <command> -h') for available klutter commands and options.");
  }
}
