import 'dart:math';

import 'package:explosion_animation/src/color_mixin.dart';
import 'package:explosion_animation/src/path_mixin.dart';
import 'package:flutter/cupertino.dart';

class DropPath extends PathMixin with ColorMixin {
  int direction;
  DropPath({Offset initialPosition, double initialRadius, Offset center})
      : super(
            initialRadius: initialRadius,
            initialPosition: initialPosition,
            center: center){
    Random _random = Random();
    direction = _random.nextBool() ? 1 : -1;
    color = Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }
  @override
  double getR(double t) {
    return initialRadius * pow(1 - Curves.easeInExpo.transform(t/10),2);
  }

  @override
  Offset getOffset(double t) {
    final x = initialPosition.dx +(t/10)* direction * (center.dx);
    final y = initialPosition.dy- ((initialPosition.dy/20)*t - 0.5 * 10*pow(t, 2));
    print(y);
    return Offset(x,y);
  }

  @override
  Color getColor(double t) {
    return color.withOpacity((10-t)/10);
  }
}
