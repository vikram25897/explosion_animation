import 'dart:math';

import 'package:flutter/material.dart';
final V = 4;
const END_VALUE = 1.4;
class Particle {
  double alpha;
  Color color;
  double cx;
  double cy;
  double radius;
  double baseCx;
  double baseCy;
  double baseRadius;
  double top;
  double bottom;
  double mag;
  double neg;
  double life;
  double overflow;


  void advance(double factor) {
    double f = 0.0;
    double normalization = factor / END_VALUE;
    if (normalization < life || normalization > 1 - overflow) {
      alpha = 0;
      return;
    }
    normalization = (normalization - life) / (1 - life - overflow);
    double f2 = normalization * END_VALUE;
    if (normalization >= 0.7) {
      f = (normalization - 0.7) / 0.3;
    }
    alpha = 1.0 - f;
    f = bottom * f2;
    cx = baseCx + f;
    cy = (baseCy - this.neg * pow(f, 2.0)) - f * mag;
    radius = V + (baseRadius - V) * f2;
  }
}