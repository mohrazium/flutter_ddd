import 'dart:async';
import 'dart:io';

import 'package:console/console.dart';

var _progress = ProgressBar();
var _i = 0;
var _lg = 1;
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
        stdout.write(res.stdout);
        stderr.write(res.stderr);
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

  void log(String msg, [bool isMarked = false]) async {
    if (!_completed) {
      Console.eraseLine(1);
    }
    var marked = isMarked ? "[${Icon.HEAVY_CHECKMARK}]" : "";
    stdout.writeln('FLUTTER-DDD => $msg $marked');
    _progress.update(_i);
    if (_lg == 34) {
      _completed = true;
    } else {
      _lg++;
      if (_i / 3 == 2) {
        _i = _i + 4;
      } else {
        _i = _i + 3;
      }
    }
  }
}
