import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnAddClick = Function();

/// 科目创建弹出框 <br/>
class SubjectCreateDialog extends Dialog {
  final TextStyle textStyleLabel = new TextStyle(
    color: Colors.blue,
    fontSize: 14.0,
  );
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

  final TextEditingController tagsEditingController;
  final TextEditingController nameEditingController;
  final TextEditingController descEditingController;
  final OnAddClick onAddClick;

  SubjectCreateDialog({
    Key key,
    this.tagsEditingController,
    this.nameEditingController,
    this.descEditingController,
    this.onAddClick,
  }) : super(key: key);

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
          Text("新增科目", style: textStyleTitle),
        ]),
      ),

      /// 标签
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(children: <Widget>[
          Text("标签：", style: textStyleLabel),
          Expanded(
            child: TextField(
              style: textStyleEdit,
              autofocus: false,
              maxLines: 1,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: '请输入标签（必填）',
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
                LengthLimitingTextInputFormatter(10),
              ],
              controller: tagsEditingController,
            ),
          ),
        ]),
      ),

      /// 名称
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(children: <Widget>[
          Text("名称：", style: textStyleLabel),
          Expanded(
            child: TextField(
              style: textStyleEdit,
              autofocus: false,
              maxLines: 1,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: '请输入名称（必填）',
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
                LengthLimitingTextInputFormatter(10),
              ],
              controller: nameEditingController,
            ),
          ),
        ]),
      ),

      /// 描述
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text("描述：", style: textStyleLabel),
            ),
            Expanded(
              child: TextField(
                style: textStyleEdit,
                autofocus: false,
                maxLines: 3,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  hintText: '请输入描述（可选）',
                  hintStyle: textStyleEditHint,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(200),
                ],
                controller: descEditingController,
              ),
            ),
          ],
        ),
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
                if (onAddClick != null) onAddClick();
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text("添加", style: textStyleBtn),
              ),
            ),
          ),
          Container(width: 0.5, height: 50, color: Colors.white),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                DialogExt.instance.hideDialog(context);
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text("取消", style: textStyleBtn),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}
