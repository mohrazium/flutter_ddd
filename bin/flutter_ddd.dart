import 'dart:io';

import 'package:flutter_ddd/args_parser.dart';
import 'package:flutter_ddd/builder.dart';

import 'flutter_ddd.reflectable.dart';

Future<void> main(List<String> arguments) async {
  String? org;
  List<String> features = ['auth', 'users', 'dashboard'];
  initializeReflectable();

  var args = Args()..parse(arguments);

  if (args.help) {
    print(args.usage());
    exit(0);
  }

  if (args.organization == "com.mohratech.mohrazium.") {
    org = args.organization + args.projectName;
  }
  if (args.cleanFeatures.isNotEmpty) {
    features.clear();
    features = args.cleanFeatures.split(',');
  } else {
    features.addAll(args.features.split(','));
  }

  Builder builder = Builder(
      projectName: args.projectName,
      organization: org ?? args.organization,
      features: features,
      projectDir: args.projectDir);

  await builder.build().then((value) => exit(0));
}
