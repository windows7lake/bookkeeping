import 'package:permission_handler/permission_handler.dart';

//enum PermissionGroup {
//  /// The unknown permission only used for return type, never requested
//  unknown,
//
//  /// Android: Calendar
//  /// iOS: Calendar (Events)
//  calendar,
//
//  /// Android: Camera
//  /// iOS: Photos (Camera Roll and Camera)
//  camera,
//
//  /// Android: Contacts
//  /// iOS: AddressBook
//  contacts,
//
//  /// Android: Fine and Coarse Location
//  /// iOS: CoreLocation (Always and WhenInUse)
//  location,
//
//  /// Android: Microphone
//  /// iOS: Microphone
//  microphone,
//
//  /// Android: Phone
//  /// iOS: Nothing
//  phone,
//
//  /// Android: Nothing
//  /// iOS: Photos
//  photos,
//
//  /// Android: Nothing
//  /// iOS: Reminders
//  reminders,
//
//  /// Android: Body Sensors
//  /// iOS: CoreMotion
//  sensors,
//
//  /// Android: Sms
//  /// iOS: Nothing
//  sms,
//
//  /// Android: External Storage
//  /// iOS: Nothing
//  storage,
//
//  /// Android: Microphone
//  /// iOS: Speech
//  speech,
//
//  /// Android: Fine and Coarse Location
//  /// iOS: CoreLocation - Always
//  locationAlways,
//
//  /// Android: Fine and Coarse Location
//  /// iOS: CoreLocation - WhenInUse
//  locationWhenInUse,
//
//  /// Android: None
//  /// iOS: MPMediaLibrary
//  mediaLibrary
//
//  /// Android: Check notification enable
//  /// iOS: Check and request notification permission
//  notification
//}
typedef Granted = Function();
typedef Denied = Function();

class PermissionExt {
  /// 权限检测：（true：权限通过   false：权限未通过）
  static Future<bool> checkPermission(PermissionGroup permission) async {
    final PermissionStatus _permissionStatus =
        await PermissionHandler().checkPermissionStatus(permission);
    return _permissionStatus == PermissionStatus.granted;
  }

  /// service检测
  /// PermissionGroup.location on Android
  /// PermissionGroup.location, PermissionGroup.locationWhenInUser, PermissionGroup.locationAlways or PermissionGroup.sensors on iOS
  /// 只对上面的几种生效，其他的返回 ServiceStatus.notApplicable
  static Future<bool> checkService() async {
    final ServiceStatus _serviceStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    return _serviceStatus == ServiceStatus.enabled;
  }

  /// 权限请求
  static Future<void> requestPermission(
    PermissionGroup permission, {
    Granted granted,
    Denied denied,
  }) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    var _permissionStatus = permissionRequestResult[permission];
    if (_permissionStatus == PermissionStatus.granted) {
      if (granted != null) granted();
    } else {
      if (denied != null) denied();
    }
  }

  /// 打开应用设置
  static Future<bool> openAppSettings() async {
    bool isOpened = await PermissionHandler().openAppSettings();
    return isOpened;
  }
}
