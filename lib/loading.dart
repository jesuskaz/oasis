import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const Loading.rectangular({this.width = double.infinity, required this.height})
      : this.shapeBorder = const RoundedRectangleBorder();

  const Loading.circular(
      {this.width = double.infinity,
        required this.height,
        this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    //  baseColor: Colors.grey[300],
    //       highlightColor: Colors.grey[100],
    baseColor: Colors.grey,
    highlightColor: Colors.grey,
    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.grey,
        shape: shapeBorder,
      ),
    ),
  );
}
