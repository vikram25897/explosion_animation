import 'dart:core';

import 'package:explosion_animation/src/port/animator.dart';
import 'package:flutter/cupertino.dart';
class Utils {
  static double density;
  Utils();
  static getDensity(MediaQueryData data){
    density = data.devicePixelRatio;
    X = Utils.dp2Px(5).toDouble();
    Y = Utils.dp2Px(20).toDouble();
    V = Utils.dp2Px(2).toDouble();
    W = Utils.dp2Px(1).toDouble();
  }
  static int dp2Px(int dp) {
    return (dp * density).round();
  }
}