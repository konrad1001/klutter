import 'package:Klutter/runner.dart';

Future<void> main(List<String> args) async {
  try {
    await runner.run(args);
  } catch (e) {
    print(e);
    print(
      "Run 'klutter -h' (or 'klutter <command> -h') for available klutter commands and options.",
    );
  }
}
