import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastExt {
  static void show(String msg, {Toast length = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: length,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void cancel() {
    Fluttertoast.cancel();
  }
}
