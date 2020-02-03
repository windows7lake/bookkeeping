import 'package:bookkeeping/widget/switcher/state_switcher.dart';

abstract class BaseState {
  bool loading();

  bool error();

  bool empty();

  PageState switchState();
}
