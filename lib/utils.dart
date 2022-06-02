import 'dart:async';
import 'dart:io';

import 'package:console/console.dart';

var _progress = ProgressBar();
var _i = 0;
var _lg = 0;
bool _completed = false;

class Utils {
  Utils() {
    Console.initialized;
    _progress.update(_i);
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_completed) {
        t.cancel();
      }
    });
  }

  Future<void> runCommand(String cmd, [List<String>? args]) async {
    var res = await Process.run(cmd, args ?? []);
    switch (res.exitCode) {
      case 0:
        if (res.stdout != "") log(res.stdout);
        break;
      case 1:
        log("Warning.");
        stdout.write(res.stdout);
        stderr.write(res.stderr);
        break;
      case 2:
        log("an Error was happened.");
        stdout.write(res.stdout);
        stderr.write(res.stderr);
        break;
      default:
    }
  }

  void log(String msg, [bool isMarked = false, bool isLatest = false]) async {
    await Future.delayed(const Duration(milliseconds: 250)).whenComplete(() {
      if (!_completed) {
        Console.eraseLine(1);
      }
      var marked = isMarked ? "[${Icon.HEAVY_CHECKMARK}]" : "";
      stdout.writeln('FLUTTER-DDD => $msg $marked');
      if (isLatest) {
        _i = _i + (100 - _i);
      }
      _progress.update(_i);
      if (_i != 100) {
        _i += 1;
      } else {
        _completed = true;
      }
    });
  }
}
