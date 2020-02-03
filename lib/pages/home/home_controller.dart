import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/pages/home/home_model.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:bookkeeping/routes/route_manager.dart';

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
      case 0:
        model.selectedIndex = 0;
        break;
      case 1:
        model.selectedIndex = 1;
        break;
      case 2:
        model.selectedIndex = 2;
        break;
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
}
