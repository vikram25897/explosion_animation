import 'package:explosion_animation/src/port/animator.dart';
import 'package:explosion_animation/src/port/utils.dart';
import 'package:flutter/material.dart';

class Exxplode extends StatefulWidget{
  final Widget child;
  const Exxplode({Key key, this.child}) : super(key: key);
  createState()=>_ExplodeState();
}
class _ExplodeState extends State<Exxplode> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> animation;
  GlobalKey renderKey = GlobalKey();
  Rect bounds;
  ExplosionAnimator animator;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = new Tween<double>(begin: 0.0,end: 0.6).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInExpo
      )
    );
    controller.addListener((){
      setState(() {
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        bounds = renderKey.currentContext.findRenderObject().paintBounds;
        animator = ExplosionAnimator(bounds);
        animator.isStarted = true;
        controller.forward();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Utils.getDensity(MediaQuery.of(context));
    return CustomPaint(
      foregroundPainter: CustomParticles(animator, animation.value),
      child: Container(
        key: renderKey,
        child: controller.isAnimating ? SizedBox():widget.child,
      ),
    );
  }
}
class CustomParticles extends CustomPainter{
  final ExplosionAnimator animator;
  final double t;
  CustomParticles(this.animator, this.t);
  @override
  void paint(Canvas canvas, Size size) {
    animator?.draw(canvas, t);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}