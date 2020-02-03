import 'dart:io';

import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageFile = Function(File file);

/// 图片选择设置框 <br/>
class ImagePickerDialog extends Dialog {
  final TextStyle textStyle = new TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );

  final OnImageFile onImageFile;

  ImagePickerDialog({Key key, this.onImageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 190,
        child: Column(children: <Widget>[
          InkWell(
            onTap: () {
              DialogExt.instance.hideDialog(context);
              getAndCropImage(ImageSource.camera);
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: double.infinity,
              color: Colors.white.withAlpha(180),
              child: Text("拍照", style: textStyle),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade200,
          ),
          InkWell(
            onTap: () {
              DialogExt.instance.hideDialog(context);
              getAndCropImage(ImageSource.gallery);
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: double.infinity,
              color: Colors.white.withAlpha(180),
              child: Text("从相册中选择", style: textStyle),
            ),
          ),
          Container(
            height: 8,
            width: double.infinity,
            color: Colors.grey.shade100,
          ),
          InkWell(
            onTap: () {
              DialogExt.instance.hideDialog(context);
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: double.infinity,
              color: Colors.white.withAlpha(180),
              child: Text("取消", style: textStyle),
            ),
          ),
        ]),
      ),
    );
  }

  /// 获取并裁剪图片
  Future<void> getAndCropImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: '裁剪',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    if (onImageFile != null) onImageFile(croppedFile);
  }
}
