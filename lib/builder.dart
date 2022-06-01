import 'dart:io';
import 'package:flutter_ddd/utils.dart';

class Builder {
  final String projectName;
  final String organization;
  final List<String> features;
  final String projectDir;
  late String _libFolder;
  final Utils utils = Utils();
  Builder({
    required this.projectName,
    required this.organization,
    required this.features,
    required this.projectDir,
  });

  void build() {
    _createBase();
  }

  Future<void> _createBase() async {
    _libFolder = "$projectDir/$projectName/lib/src";
    await utils.runCommand("mkdir", ["-p", _libFolder]).then((value) => utils.log("lib folder created."));
    await utils.runCommand("mkdir", ["-p", "$projectDir/$projectName/bin"])
        .then(((value) => utils.log("FLUTTER-DDD => bin folder created.")));
    await utils.runCommand("touch", ["$projectDir/$projectName/bin/main.dart"]);
    await utils.runCommand("touch", ["$projectDir/$projectName/lib/$projectName.dart"]);
    await File("$projectDir/$projectName/bin/main.dart").writeAsString('''
    //import 'package:$projectName/$projectName.dart';
    // TODO:Run application from here.
    // void main() {
    //   Application().run();
    // }
       ''').then((value) async {
      utils.log("lib and bin folder and main.dart file created.");
      utils.log("Creating sub-folders ...");
      await _createApp();
      await _createCommon();
      await _createConfig();
      await _createConstants();
      await _createExceptions();
      await _createSettings();
      await _createLocalization();
      await _createRouter();
      await _createUtils();
      await _createFeatures();
      utils.log("Running 'flutter create'...");
      await utils.runCommand("flutter", ["create", projectName, "--org", organization]).then((v) async {
        utils.log("All done!");
        utils.log("Opening VS Code ...");

        await utils.runCommand("code", [projectName]);
      });
      await utils.runCommand("rm", ["$projectDir/$projectName/lib/main.dart"]);
      await utils.runCommand("rm", ["$projectDir/$projectName/test/widget_test.dart"]);
    });
  }

  Future<void> _createApp() async {
    await utils.runCommand("mkdir", ["-p", "$_libFolder/app/src"]).then((value) async {
      await utils.runCommand("touch", ["$_libFolder/app.dart"]);
      await utils.runCommand("touch", ["$_libFolder/app/src/entry_point.dart"]);
      await utils.runCommand("touch", ["$_libFolder/app/src/application.dart"]);
    }).then((value) {
      utils.log("$projectName app entry lib created.");
    });
  }

  Future<void> _createCommon() async {
    await utils.runCommand("touch", ["$_libFolder/common.dart"]);
    await utils.runCommand("mkdir", [
      "-p",
      "$_libFolder/common/src/client/provider",
      "$_libFolder/common/src/database",
      "$_libFolder/common/src/storage",
      "$_libFolder/common/src/components/widgets",
      "$_libFolder/common/src/components/dialogs",
      "$_libFolder/common/src/themes",
      "$_libFolder/common/src/services",
      "$_libFolder/common/src/pages",
      "$_libFolder/common/src/controllers",
    ]).then((value) async {
      await utils.runCommand("touch", ["$_libFolder/common/src/services/base_service.dart"]);
      await utils.runCommand("touch", ["$_libFolder/common/src/components.dart"]);
      await File("$_libFolder/common/src/services/base_service.dart").writeAsString('''
    abstract class Service<T, M> {
      Future<T> save(M model);
      Future<M?> findById(T id);
      Future<List<M>?> findAll();
      Future<bool> update(M model);
      Future<bool> delete(M model);
    }
    ''');
      utils.log("Common folder created.");
    });
  }

  Future<void> _createConfig() async {
    await File("$_libFolder/config.dart").create();
    await utils.runCommand("mkdir", [
      "-p",
      "$_libFolder/config/src/utils.logger",
      "$_libFolder/config/src/injection",
      "$_libFolder/config/src/io",
    ]).then((value) {
      utils.log("config folder created.");
    });
  }

  Future<void> _createConstants() async {
    await utils.runCommand("mkdir", ["-p", "$_libFolder/constants/src"]);
    await File("$_libFolder/constants.dart").create().then((value) {
      utils.log("constants folder created.");
    });
  }

  Future<void> _createExceptions() async {
    await utils.runCommand("mkdir", ["-p", "$_libFolder/exceptions/src"]);
    await File("$_libFolder/exceptions.dart").create().then((value) {
      utils.log("Exceptions folder created.");
    });
  }

  Future<void> _createSettings() async {
    await utils.runCommand("mkdir", ["-p", "$_libFolder/settings/src"]);
    await File("$_libFolder/settings.dart").create().then((value) {
      utils.log("Settings folder created.");
    });
  }

  Future<void> _createLocalization() async {
    await utils.runCommand("mkdir", ["-p", "$_libFolder/localization/src"]);
    await File("$_libFolder/localization.dart").create().then((value) {
      utils.log("Localization folder created.");
    });
  }

  Future<void> _createRouter() async {
    await utils.runCommand("mkdir", ["-p", "$_libFolder/router/src"]);
    await File("$_libFolder/router.dart").create().then((value) {
      utils.log("Router folder created.");
    });
  }

  Future<void> _createUtils() async {
    await File("$_libFolder/utils.dart").create();
    //! utils lib
    await utils.runCommand("mkdir", [
      "-p",
      "$_libFolder/utils/src/mapper",
      "$_libFolder/utils/src/mixins",
    ]).then((value) {
      utils.log("Utils folder created.");
    });
  }

  Future<void> _createFeatures() async {
    String featuresPath = "$_libFolder/features";
    await File("$_libFolder/features.dart").create();

    await utils.runCommand("mkdir", ["-p", featuresPath]).then((value) {
      utils.log("Features folder created.");
      for (String feature in features) {
        _createFeature(featuresPath, feature);
      }
    });
  }

  Future<void> _createFeature(String featuresPath, String featureName) async {
    String fPath = "$featuresPath/$featureName";
    await utils.runCommand("mkdir", ["-p", fPath]);
    await File("$featuresPath/$featureName.dart").create().then((value) async {
      utils.log("Creating $featureName feature...");
      await _createApplication(fPath).then((value) => utils.log("Application folder of $featureName was created."));
      await _createData(fPath).then((value) => utils.log("Data folder of $featureName was created."));
      await _createDomain(fPath).then((value) => utils.log("Domain folder of $featureName was created."));
      await _createPresentation(fPath).then((value) => utils.log("Presentation folder of $featureName was created."));
      utils.log("$featureName feature creation completed.");
    });
  }

  @override
  String toString() {
    return 'Builder(projectName: $projectName, organization: $organization, features: $features, projectDir: $projectDir)';
  }

  Future<void> _createApplication(String featurePath) async {
    final applicationPath = "$featurePath/application/services";

    await utils.runCommand("mkdir", ["-p", applicationPath]);
    await File("$featurePath/application.dart").create();
  }

  Future<void> _createData(String featurePath) async {
    await utils.runCommand("mkdir", [
      "-p",
      "$featurePath/data/repositories",
      "$featurePath/data/dtos",
      "$featurePath/data/datasources/database/daos",
      "$featurePath/data/datasources/database/tables",
      "$featurePath/data/datasources/api/clients",
      "$featurePath/data/datasources/api/responses",
      "$featurePath/data/datasources/api/requests",
    ]);
    await File("$featurePath/data.dart").create();
  }

  Future<void> _createDomain(String featurePath) async {
    await utils.runCommand("mkdir", [
      "-p",
      "$featurePath/domain/models",
    ]);
    await File("$featurePath/domain.dart").create();
  }

  Future<void> _createPresentation(String featurePath) async {
    await utils.runCommand("mkdir", [
      "-p",
      "$featurePath/presentation/controllers",
      "$featurePath/presentation/pages",
      "$featurePath/presentation/views",
      "$featurePath/presentation/bindings",
    ]);
    await File("$featurePath/presentation.dart").create();
  }
}
