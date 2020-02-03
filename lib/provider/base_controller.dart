import 'package:flutter/material.dart';

abstract class BaseController<T> extends ChangeNotifier {
  T model;
}
