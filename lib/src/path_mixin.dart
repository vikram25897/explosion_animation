import 'package:flutter/material.dart';

abstract class PathMixin {
  Offset initialPosition;
  double initialRadius;
  Offset center;
  PathMixin({this.initialPosition, this.initialRadius, this.center});
  Offset getOffset(double t);
  double getR(double t);
}
