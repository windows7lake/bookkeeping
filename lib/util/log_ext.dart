import 'package:flutter/foundation.dart';
import 'dart:developer' as logger;

class LogExt {
  static void log(Object object) {
    if (!kReleaseMode) logger.log("$object");
  }

  /// 打印Json格式化数据
  static void printJson(msg) {
    String prettyPrint = msg
        .toString()
        .replaceAll(",\"", ",\n\"")
        .replaceAll(",{", ",\n{")
        .replaceAll(",[", ",\n[")
        .replaceAll(":{", ":\n{")
        .replaceAll("},", "},\n \n")
        .replaceAll("[", "\n       [\n")
        .replaceAll("]", "\n       ]\n");
    if (prettyPrint.length < 800) {
      print(prettyPrint);
      return;
    }
    prettyPrint.split("\n").forEach((text) {
      print("$text");
    });
  }
}
