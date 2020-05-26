import 'package:explosion_animation/src/drop_path.dart';
import 'package:flutter/cupertino.dart';

class ParticlesPainter extends CustomPainter{
  final double t;
  final List<DropPath> dropPaths;
  ParticlesPainter({@required this.t, @required this.dropPaths});
  @override
  void paint(Canvas canvas, Size size) {
    print(dropPaths.length);
    if(t>0) {
      Paint paint = Paint();
      paint.style = PaintingStyle.fill;
      dropPaths.forEach((path) {
        paint.color = path.getColor(t);
        canvas.drawCircle(path.getOffset(t), path.getR(t), paint);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}