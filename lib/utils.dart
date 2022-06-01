import 'dart:async';
import 'dart:io';

import 'package:console/console.dart';
import 'package:intl/intl.dart';

var progress = ProgressBar();
var i = 0;
var lg = 1;
bool completed = false;

class Utils {
  Utils() {
    Console.initialized;
    progress.update(i);
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (completed) {
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

  void log(String msg) async {
    if (!completed) {
      Console.eraseLine(1);
    }
    stdout.writeln('\n\x1b[38;5;39mFLUTTER-DDD => $msg\x1b[0m');
    progress.update(i);
    if (lg == 34) {
      completed = true;
    } else {
      lg++;
      if (i / 3 == 2) {
        i = i + 4;
      } else {
        i = i + 3;
      }
    }
  }
}
