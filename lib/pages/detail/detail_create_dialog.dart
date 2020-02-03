import 'package:bookkeeping/cache/db/account_dao.dart';
import 'package:bookkeeping/cache/db/subject_dao.dart';
import 'package:bookkeeping/pages/detail/detail_bean.dart';
import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:bookkeeping/util/screen_ext.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnCreateItemClick = Function(int index);
typedef OnAddClick = Function(
  Account sourceAccountSelected,
  Account destAccountSelected,
  Subject subjectSelected,
  DateTime dataTime,
);

/// 账户创建弹出框 <br/>
class DetailCreateDialog extends StatefulWidget {
  final DetailBean detailBean;
  final List<Account> accountList;
  final List<Subject> subjectList;
  final TextEditingController amountEditingController;
  final TextEditingController remarkEditingController;
  final OnAddClick onAddClick;
  final OnCreateItemClick onCreateItemClick;

  DetailCreateDialog({
    Key key,
    this.detailBean,
    this.accountList,
    this.subjectList,
    this.amountEditingController,
    this.remarkEditingController,
    this.onAddClick,
    this.onCreateItemClick,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailCreateDialogState();
}

class DetailCreateDialogState extends State<DetailCreateDialog> {
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

  String title = "新增明细";
  Account sourceAccountSelected;
  Account destAccountSelected;
  Subject subjectSelected;
  DateTime dataTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.accountList.isNotEmpty) {
      sourceAccountSelected = widget.accountList[0];
      destAccountSelected = widget.accountList[0];
    }
    if (widget.subjectList.isNotEmpty) subjectSelected = widget.subjectList[0];

    if (sourceAccountSelected == null) {
      sourceAccountSelected = Account(name: "请先创建账户");
      destAccountSelected = Account(name: "请先创建账户");
    }
    if (subjectSelected == null) {
      subjectSelected = Subject(name: "请先创建科目");
    }

    /// 如果detailBean不为空，说明是修改数据
    if (widget.detailBean != null) {
      title = "修改明细";
      widget.accountList.forEach((accountBean) {
        if (widget.detailBean.sourceAccountId == accountBean.id) {
          sourceAccountSelected = accountBean;
        }
        if (widget.detailBean.destAccountId == accountBean.id) {
          destAccountSelected = accountBean;
        }
      });
      widget.subjectList.forEach((subjectBean) {
        if (widget.detailBean.subjectId == subjectBean.id) {
          subjectSelected = subjectBean;
        }
      });
      dataTime = widget.detailBean?.updatedAt == null
          ? DateTime.now()
          : DateTime.parse(widget.detailBean?.updatedAt);
      widget.amountEditingController?.text =
          "${widget.detailBean?.amount ?? ''}";
      widget.remarkEditingController?.text =
          "${widget.detailBean?.remark ?? ''}";
    }
  }

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
      renderTitle(),
      renderSubject(),
      renderSourceAccount(),
      renderDestAccount(),
      renderDateTime(),
      renderAmount(),
      renderRemark(),
      renderButton(),
    ]);
  }

  /// 标题部分
  Widget renderTitle() {
    return Container(
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
        Text(title, style: textStyleTitle),
      ]),
    );
  }

  /// 科目
  Widget renderSubject() {
    if (subjectSelected?.name == "请先创建科目") {
      return renderCreateItem("科目", "请先创建科目", () {
        if (widget.onCreateItemClick != null) widget.onCreateItemClick(2);
      });
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(children: <Widget>[
        Text("科目：", style: textStyleLabel),
        Expanded(
          child: DropdownButton<Subject>(
            value: subjectSelected,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            itemHeight: 55,
            underline: Container(height: 1, color: Colors.blue),
            onChanged: (Subject value) {
              subjectSelected = value;
              setState(() {});
            },
            items: widget.subjectList.map((subject) {
              return DropdownMenuItem<Subject>(
                value: subject,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: ScreenExt.instance.width - 200,
                  child: Text("${subject.name}", style: textStyleEdit),
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  /// 来源账户
  Widget renderSourceAccount() {
    if (sourceAccountSelected?.name == "请先创建账户") {
      return renderCreateItem("来源账户", "请先创建账户", () {
        if (widget.onCreateItemClick != null) widget.onCreateItemClick(1);
      });
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(children: <Widget>[
        Text("来源账户：", style: textStyleLabel),
        Expanded(
          child: DropdownButton<Account>(
            value: sourceAccountSelected,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            itemHeight: 55,
            underline: Container(height: 1, color: Colors.blue),
            onChanged: (Account value) {
              sourceAccountSelected = value;
              setState(() {});
            },
            items: widget.accountList.map((account) {
              return DropdownMenuItem<Account>(
                value: account,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: ScreenExt.instance.width - 220,
                  child: Text("${account.name}", style: textStyleEdit),
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  /// 目标账户
  Widget renderDestAccount() {
    if (destAccountSelected?.name == "请先创建账户") {
      return renderCreateItem("目标账户", "请先创建账户", () {
        if (widget.onCreateItemClick != null) widget.onCreateItemClick(1);
      });
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(children: <Widget>[
        Text("目标账户：", style: textStyleLabel),
        Expanded(
          child: DropdownButton<Account>(
            value: destAccountSelected,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            itemHeight: 55,
            underline: Container(height: 1, color: Colors.blue),
            onChanged: (Account value) {
              destAccountSelected = value;
              setState(() {});
            },
            items: widget.accountList.map((account) {
              return DropdownMenuItem<Account>(
                value: account,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: ScreenExt.instance.width - 220,
                  child: Text("${account.name}", style: textStyleEdit),
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  /// 日期
  Widget renderDateTime() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("日期：", style: textStyleLabel),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    var pickerDateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030),
                    );
                    dataTime = pickerDateTime;
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "${formatDate(
                        dataTime ?? DateTime.now(),
                        [yyyy, '年', mm, '月', dd, '日'],
                      )}",
                      style: textStyleEdit,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 1,
                  width: double.infinity,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 金额
  Widget renderAmount() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(children: <Widget>[
        Text("金额：", style: textStyleLabel),
        Expanded(
          child: TextField(
            style: textStyleEdit,
            autofocus: false,
            maxLines: 1,
            cursorColor: Colors.blue,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '请输入金额（必填）',
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
            controller: widget.amountEditingController,
          ),
        ),
      ]),
    );
  }

  /// 备注
  Widget renderRemark() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text("备注：", style: textStyleLabel),
          ),
          Expanded(
            child: TextField(
              style: textStyleEdit,
              autofocus: false,
              maxLines: 3,
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                hintText: '请输入备注（可选）',
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
              controller: widget.remarkEditingController,
            ),
          ),
        ],
      ),
    );
  }

  /// 按钮部分
  Widget renderButton() {
    return Container(
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
              if (widget.onAddClick != null)
                widget.onAddClick(
                  sourceAccountSelected,
                  destAccountSelected,
                  subjectSelected,
                  dataTime,
                );
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
    );
  }

  /// 请先创建XX 的Item
  Widget renderCreateItem(
      String label, String title, GestureTapCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("$label：", style: textStyleLabel),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (onTap != null) onTap();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 15),
                    child: Text(title, style: textStyleEdit),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 1,
                  width: double.infinity,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
