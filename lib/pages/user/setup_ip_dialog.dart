import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnConfirmClick = Function();

/// 设置IP弹出框 <br/>
class SetupIpDialog extends Dialog {
  final TextStyle textStyleEdit = new TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );
  final TextStyle textStyleEditHint = new TextStyle(
    color: Colors.grey.shade400,
    fontSize: 14.0,
  );
  final TextStyle textStyleTitle = new TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );
  final TextStyle textStyleBtn = new TextStyle(
    color: Colors.white,
    fontSize: 14.0,
  );

  final TextEditingController editingController =
      TextEditingController(text: SpManager.getString(SpParams.url));
  final OnConfirmClick onConfirmClick;

  SetupIpDialog({Key key, this.onConfirmClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: Material(
            //创建透明层
            type: MaterialType.transparency, //透明类型
            borderRadius: BorderRadius.circular(4.0),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.white,
                ),
                child: renderDialogContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderDialogContent(BuildContext context) {
    return Column(children: <Widget>[
      /// 标题部分
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
          color: Colors.blue,
        ),
        child: Row(children: <Widget>[
          Icon(Icons.border_color, color: Colors.white, size: 20),
          Padding(padding: EdgeInsets.only(left: 15)),
          Text(IntlLocalizations.of(context).ipModifyTitle,
              style: textStyleTitle),
        ]),
      ),

      /// IP输入框
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(children: <Widget>[
          Expanded(
            child: TextField(
              style: textStyleEdit,
              autofocus: false,
              maxLines: 1,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: IntlLocalizations.of(context).ipModifyEditHint,
                hintStyle: textStyleEditHint,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              controller: editingController,
            ),
          ),
        ]),
      ),

      /// 按钮部分
      Container(
        margin: EdgeInsets.only(top: 20),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
          color: Colors.blue,
        ),
        child: Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                DialogExt.instance.hideDialog(context);
                if (onConfirmClick != null) onConfirmClick();
                SpManager.setString(SpParams.url, editingController.text);
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(IntlLocalizations.of(context).hintAdd,
                    style: textStyleBtn),
              ),
            ),
          ),
          Container(width: 0.5, height: 50, color: Colors.white),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                DialogExt.instance.hideDialog(context);
                if (onConfirmClick != null) onConfirmClick();
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(IntlLocalizations.of(context).hintCancel,
                    style: textStyleBtn),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}
