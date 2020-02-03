import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AccountSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: <int>[0, 1, 2, 3, 4, 5].map((_) => renderItem()).toList(),
          ),
        ),
      ),
    );
  }

  Widget renderItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 180,
          height: 12.0,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15, top: 20),
        ),
        Container(
          width: 250,
          height: 12.0,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15, top: 8),
        ),
        Container(
          width: 220,
          height: 12.0,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15, top: 8),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.white,
          margin: EdgeInsets.only(top: 20),
        ),
      ],
    );
  }
}
