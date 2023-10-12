import 'package:flutter/material.dart';
import 'package:ottu/consts/colors.dart';
import 'package:shimmer/shimmer.dart';

///Shimmer animation
class ShimmerWidget extends StatelessWidget {
  final double height;
  const ShimmerWidget.rect({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shadowColor,
      highlightColor: Colors.grey,
      child: Container(
        height: height,
        color: Colors.grey,
      ),
    );
  }
}
