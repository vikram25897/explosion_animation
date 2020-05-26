import 'package:explosion_animation/src/drop_path.dart';
import 'package:explosion_animation/src/painter.dart';
import 'package:explosion_animation/src/path_mixin.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';

const shakeMilliseconds = 500;

class Explode extends StatefulWidget {
  final Widget child;
  final Duration explodeDuration;
  final bool instantExplode;
  final bool shakeBeforeExploding;
  final Function onFinished;
  final double shakeDistance;

  const Explode(
      {Key key,
      this.explodeDuration = const Duration(seconds: 1),
      this.child,
      this.instantExplode = true,
      this.shakeDistance = 40,
      this.shakeBeforeExploding = false,
      this.onFinished})
      : super(key: key);

  createState() => _ExplodeState();
}

class _ExplodeState extends State<Explode> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _explodeAnimation;
  Animation<double> _shakeAnimation;
  static const List<int> signs = [-1,1];
  math.Random random = new math.Random();
  final GlobalKey renderKey = GlobalKey();
  Size size;
  static const int particleCount = 300;
  List<DropPath> particles = [];
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.shakeBeforeExploding
          ? Duration(
              seconds: 1)
          : widget.explodeDuration,
    );
    _explodeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(
                0.3,
                1.0)));
    _shakeAnimation = widget.shakeBeforeExploding
        ? Tween<double>(begin: 0.0, end: 100.0).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(
                0.0, 0.3,
                curve: Curves.easeInQuint)))
        : null;
    _controller.addListener(() {
      setState(() {});
    });
    if (widget.onFinished != null)
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onFinished();
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        size = renderKey.currentContext.findRenderObject().paintBounds.size;
        createParticles();
        if(!widget.shakeBeforeExploding) _controller.forward();
      });
    });
    Future.delayed(Duration(seconds: 2)).then((_) {
      if (widget.instantExplode && widget.shakeBeforeExploding) _controller.forward();
    });
    super.initState();
  }
  createParticles(){
    for(int i =0; i< particleCount;i++){
      particles.add(DropPath(
        initialPosition: Offset(random.nextInt(size.width.toInt()).toDouble(),random.nextInt(size.height.toInt()).toDouble()),
        initialRadius: random.nextDouble()*12,
        center: Offset(size.width/2,size.height/2)
      ));
    }
  }
  Vector3 shake() {
    print(_shakeAnimation.status);
    if (_controller.value>=0.3) return Vector3.all(0);
    double x = widget.shakeDistance * random.nextDouble()*(random.nextBool()?-1:1);
    double y = widget.shakeDistance * random.nextDouble()*(random.nextBool()?-1:1);
    print(Size(x,y));
    return Vector3(x, y, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: renderKey,
      transform:
          widget.shakeBeforeExploding ? Matrix4.translation(shake()) : null,
      child: CustomPaint(
          size: size ?? Size.zero,
          painter: ParticlesPainter(
            dropPaths: particles,
            t: _explodeAnimation.value
          ),
          child: _explodeAnimation.value==0 ? widget.child : null),
    );
  }
}
