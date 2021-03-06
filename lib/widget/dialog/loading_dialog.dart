import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/util/string_ext.dart';
import 'package:flutter/material.dart';

/// 加载框 <br/>
///
/// @param [text] 自定义文本 <br/>
class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center(
        //保证控件居中效果
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    StringExt.isNullOrEmpty(text)
                        ? IntlLocalizations.of(context).loading
                        : text,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
