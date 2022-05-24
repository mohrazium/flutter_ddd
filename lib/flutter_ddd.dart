import 'dart:io';

Future<void> pros() async {
  final currentDir = Directory.current.path;

  stdout.writeln('Creating flutter project with clean architecture...');

  stdout.writeln('Input project name with sank_case format:');
  var projectName = stdin.readLineSync();
  stdout.writeln('Please input organization:');
  var org = stdin.readLineSync();

  stdout
      .writeln('Please add name of features you want to create. (Press ENTER to add and hit enter twice to continue):');

  String? readLine;
  List<String> features = [];

  while (true) {
    readLine = stdin.readLineSync();
    if (readLine!.isNotEmpty) {
      if (features.contains(readLine)) {
        stdout.writeln("Duplicated feature name $readLine");
      } else {
        features.add(readLine);
      }
    } else {
      break;
    }
  }

  stdout.writeln("${features.length} features added.");
  final libFolder = "$currentDir/$projectName/lib/src";
  await runner("mkdir", ["-p", libFolder]);

  //! common lib
  await runner("mkdir", [
    "-p",
    "$libFolder/common/src/api/provider",
    "$libFolder/common/src/database",
    "$libFolder/common/src/storage",
    "$libFolder/common/src/components/widgets",
    "$libFolder/common/src/components/dialogs",
    "$libFolder/common/src/themes",
    "$libFolder/common/src/services",
  ]);
  await runner("touch", ["$libFolder/common/src/services/base_service.dart"]);
  await File("$libFolder/common/src/services/base_service.dart").writeAsString(
    '''
part of common;

abstract class Service<T, M> {
  Future<T> save(M model);
  Future<M?> findById(T id);
  Future<List<M>?> findAll();
  Future<bool> update(M model);
  Future<bool> delete(M model);
}
''',
  );
  await runner("touch", ["$libFolder/common/common.dart"]);
  await File("$libFolder/common/common.dart").writeAsString(
    '''
library common;

part 'src/services/base_service.dart';

''',
  ).then((value) {
    stdout.writeln("common lib created.");
  });

  //! constants lib
  await runner("mkdir", ["-p", "$libFolder/constants/src"]);
  await runner("touch", ["$libFolder/constants/constants.dart"]);
  await File("$libFolder/constants/constants.dart").writeAsString('library constants;').then((value) {
    stdout.writeln("constants library created.");
  });

  //! exceptions lib
  await runner("mkdir", ["-p", "$libFolder/exceptions/src"]);
  await runner("touch", ["$libFolder/exceptions/exceptions.dart"]);
  await File("$libFolder/exceptions/exceptions.dart").writeAsString('library exceptions;').then((value) {
    stdout.writeln("exceptions library created.");
  });

  //! localization lib
  await runner("mkdir", ["-p", "$libFolder/localization/src"]);
  await runner("touch", ["$libFolder/localization/localization.dart"]);
  await File("$libFolder/localization/localization.dart").writeAsString('library localization;').then((value) {
    stdout.writeln("localization library created.");
  });

  //! router lib
  await runner("mkdir", ["-p", "$libFolder/router/src"]);
  await runner("touch", ["$libFolder/router/router.dart"]);
  await File("$libFolder/router/router.dart").writeAsString('library router;').then((value) {
    stdout.writeln("router library created.");
  });

  //! config lib
  await runner("mkdir", [
    "-p",
    "$libFolder/config/src/logger",
    "$libFolder/config/src/injection",
  ]);
  await runner("touch", ["$libFolder/config/config.dart"]);
  await File("$libFolder/config/config.dart").writeAsString('library config;').then((value) {
    stdout.writeln("config library created.");
  });

  //! utils lib
  await runner("mkdir", [
    "-p",
    "$libFolder/utils/src",
    "$libFolder/utils/src/io",
    "$libFolder/utils/src/mapper",
    "$libFolder/utils/src/mixins",
  ]);
  await runner("touch", [
    "$libFolder/utils/utils.dart",
  ]);
  await File("$libFolder/utils/utils.dart").writeAsString('library utils;').then((value) {
    stdout.writeln("utils library created.");
  });

  //! app entry lib
  await runner("mkdir", ["-p", "$libFolder/app/src"]);
  await runner("touch", ["$libFolder/app/$projectName.dart"]);
  await runner("touch", ["$libFolder/app/src/${projectName}_entry_point.dart"]);
  await runner("touch", ["$libFolder/app/src/application.dart"]);
  await File("$libFolder/app/src/application.dart").writeAsString("part of $projectName");
  await File("$libFolder/app/src/${projectName}_entry_point.dart").writeAsString("part of $projectName");

  await File("$libFolder/app/$projectName.dart").writeAsString(
    '''
library $projectName;

part 'src/application.dart';
part 'src/${projectName}_entry_point.dart';

''',
  ).then((value) {
    stdout.writeln("$projectName app entry lib created.");
  });

  var featuresFolder = "$libFolder/features";

  //! features folder
  await runner("mkdir", ["-p", featuresFolder]);

  for (var feature in features) {
    await runner("mkdir", ["-p", "$featuresFolder/$feature/src"]);
    await runner("touch", ["$featuresFolder/$feature/$feature.dart"]);
    await File("$featuresFolder/$feature/$feature.dart").writeAsString(
      '''
library $feature;

part 'src/domain/models/${feature}_model.dart';
''',
    ).then((value) async {
      var fPath = "$featuresFolder/$feature/src/";
      await runner("mkdir", [
        "-p",
        "$fPath/app/services",
        "$fPath/data",
        "$fPath/domain/models",
        "$fPath/presentation",
        "$fPath/presentation/controllers",
        "$fPath/presentation/pages",
        "$fPath/presentation/views",
        "$fPath/presentation/bindings",
      ]);
      await runner("touch", ["$fPath/domain/models/${feature}_model.dart"]);
      await File("$fPath/domain/models/${feature}_model.dart").writeAsString('part of $feature;');
      stdout.writeln("$feature feature created.");
    });
  }

  await runner("flutter", ["create", projectName!, "--org", org!]);
  await runner("code", [projectName]);
  stdout.writeln("All done!");
}

Future<void> runner(String cmd, [List<String>? args]) async {
  var res = await Process.run(cmd, args ?? []);
  switch (res.exitCode) {
    case 0:
      stdout.write(res.stdout);
      stderr.write(res.stderr);
      break;
    case 1:
      stdout.writeln("Warning.");
      stdout.write(res.stdout);
      stderr.write(res.stderr);
      break;
    case 2:
      stdout.writeln("an Error was happened.");
      stdout.write(res.stdout);
      stderr.write(res.stderr);
      break;
    default:
  }
}
