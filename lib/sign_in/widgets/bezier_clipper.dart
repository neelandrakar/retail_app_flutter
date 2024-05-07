import 'package:flutter/material.dart';

class BezierClipper1 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var heightOffset = height*0.4;
    Path path = Path();

    path.lineTo(0, height-heightOffset);

    path.quadraticBezierTo(
        width*1.4,
        height*1.2,
        width,
        height - heightOffset);

    path.lineTo(width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}