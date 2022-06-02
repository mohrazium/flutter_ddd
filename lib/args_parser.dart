import 'dart:io';

import 'package:smart_arg/smart_arg.dart';

@SmartArg.reflectable
@Parser(description: 'A CLI for Creating flutter project with clean architecture...')
class Args extends SmartArg {
  @StringArgument(
    help: '''
      Name of flutter project to create
      example : flutter_project
      must be snake_case name
      ''',
    isRequired: true,
    short: 'p',
  )
  late String projectName;

  @StringArgument(
    help: '''
          Organization for packages of project
          default is : com.mohratech.mohrazium.project_name 
          ''',
    short: 'o',
  )
  String organization = 'com.mohratech.mohrazium.';

  @StringArgument(
    help: '''
          Project directory, where is to be create...
          default is : where is this app is ran.
          ''',
    short: 'd',
  )
  String projectDir = Directory.current.path;

  @StringArgument(
    help: '''
          List of features you wish to create in this project...
          default features is : auth, users, dashboard,
          you should separated feature names with ,
          ''',
    short: 'f',
    isRequired: false,
  )
  String features = '';
  @StringArgument(
    help: '''
          List of features you wish to create in this project...
          default features is : this is a clean list of features.
          you should separated feature names with ,
          ''',
    short: 'c',
    isRequired: false,
  )
  String cleanFeatures = '';

  @HelpArgument()
  bool help = false;
}
