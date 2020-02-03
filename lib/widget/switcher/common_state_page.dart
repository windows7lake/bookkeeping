import 'package:flutter/material.dart';

/// 状态页面
class CommonStatePage extends StatelessWidget {
  final String image;
  final String text;

  CommonStatePage({Key key, this.image, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            image ?? "assets/images/state_empty.png",
            width: 130,
            height: 130,
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              text,
              style: TextStyle(color: Color(0xFF999999), fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
