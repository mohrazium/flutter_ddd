import 'dart:io';

import 'package:flutter_ddd/args_parser.dart';
import 'package:flutter_ddd/builder.dart';

import 'flutter_ddd.reflectable.dart';

void main(List<String> arguments) {

  String? org;
  initializeReflectable();

  var args = Args()..parse(arguments);

  if (args.help) {
    print(args.usage());
    exit(0);
  }

  if (args.organization == "com.mohratech.mohrazium.") {
    org = args.organization + args.projectName;
  }

  Builder builder = Builder(
      projectName: args.projectName,
      organization: org ?? args.organization,
      features: args.features,
      projectDir: args.projectDir);

  builder.build();
}
