import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/pages/home/home_model.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:bookkeeping/routes/route_manager.dart';
import 'package:bookkeeping/routes/route_params.dart';
import 'package:bookkeeping/util/toast_ext.dart';

class HomeController extends BaseController<HomeModel> {
  HomeController() {
    model = HomeModel();
  }

  /// 打开Drawer
  void openDrawer() {
    model.scaffoldKey.currentState.openDrawer();
  }

  /// Drawer Item 点击事件
  void onDrawerItemSelected(int index) {
    switch (index) {
      case 0: // 明细
        model.selectedIndex = 0;
        break;
      case 1: // 账户
        model.selectedIndex = 1;
        break;
      case 2: // 科目
        model.selectedIndex = 2;
        break;
      case 3: // 设置
        RouteManager.instance.pop();
        RouteManager.instance.push(RoutePageType.setting);
        return;
      default:
        model.selectedIndex = 0;
        break;
    }
    notifyListeners();
    RouteManager.instance.pop();
  }

  /// 获取头像路径
  String getAvatarPath() {
    return SpManager.getString(SpParams.avatar);
  }

  /// 获取用户名
  String getUsername() {
    return SpManager.getString(SpParams.username);
  }

  /// 返回按钮点击退出应用
  Future<bool> onBackKeyClick() async {
    if (model.lastPressed == null ||
        DateTime.now().difference(model.lastPressed) > Duration(seconds: 2)) {
      // 两次点击间隔超过1秒则重新计时
      model.lastPressed = DateTime.now();
      ToastExt.show("再点击一次退出应用");
      return false;
    }
    return true;
  }
}
