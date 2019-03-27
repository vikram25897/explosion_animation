library explosion_animation;
import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vector_math/vector_math_64.dart';
List<Particle> particles;
class Explode extends StatefulWidget{
  final String path;
  final BoxFit fit;
  final int particleCount;
  final Size size;
  final ExplodeType type;
  final List<Color> colors;
  final bool isAsset;
  static GlobalKey<_ExplodeState> getKey(){
    return GlobalKey<_ExplodeState>();
  }
  final Duration duration;
  const Explode({Key key,this.colors,this.type = ExplodeType.Spread,@required this.path,this.isAsset = false,@required this.size,this.fit = BoxFit.cover,this.duration=const Duration(
  seconds: 1,milliseconds: 300
  ),this.particleCount=100}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ExplodeState();
}
class _ExplodeState extends State<Explode> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> animation;
  Animation<double> animationTwo;
  Animation<double> shakeAnimation;
  var image;
  Math.Random random = new Math.Random();
  List<Color> colors = [];
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this,duration: widget.duration)..addListener((){setState(() {
    });});
    shakeAnimation = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: controller, curve: Interval(0.0
    ,0.2)));
    animation = Tween<double>(begin:0.0,end:1.0).animate(
        CurvedAnimation(parent: controller, curve: Interval(0.2, 1.0,curve: widget.type == ExplodeType.Spread ? Curves.linear : Curves.bounceOut)));
      if(widget.isAsset)
      image = AssetImage(widget.path);
      else image = FileImage(File(widget.path));
    check();
  }
  void explode({Function onFinish}){
    if(controller.isDismissed) {
      controller.reset();
      controller.forward();
      if (onFinish != null) {
        onFinish();
      }
    }
  }
  void check()async{
    if(widget.colors==null) {
      PaletteGenerator p = await PaletteGenerator.fromImageProvider(image);
      colors = List<Color>.of(p.paletteColors.map((p) => p.color));
    } else colors = widget.colors;
    print(colors.length);
    particles = new List<Particle>.generate(widget.particleCount, (i){
      return Particle(
        left: random.nextInt(widget.size.width.toInt()-10).toDouble(),
        top:random.nextInt(widget.size.height.toInt()-10).toDouble(),
        color: colors[i%colors.length],
        sizeFactor: random.nextInt(1000).toDouble()/1000,
        spread: widget.type == ExplodeType.Spread
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: controller.value<0.4?Transform(
        transform: Matrix4.translation(getTranslation()),
        child: Image(image: image, fit: widget.fit,
          width: widget.size==null?null:widget.size.width,
          height: widget.size == null ? null:widget.size.height,)
      ):CustomPaint(
        foregroundPainter: ParticlesPainter(animation.value),
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
        ),
      )
    );
  }
  Vector3 getTranslation() {
    double progress = shakeAnimation.value;
    double offset = 3*Math.sin(progress * Math.pi * 2);
    return Vector3(offset, offset, offset);
  }
}
class ParticlesPainter extends CustomPainter{
  final double span;
  ParticlesPainter(this.span);
  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach((particle){
      particle.advance(span,span>0.4,size.height);
      Paint paint = Paint()
      ..color = particle.color.withOpacity(Math.min(Math.max((0.4*(1-span)+1-span),0),1))
      ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(particle.left, particle.top),
          particle.sizeFactor*10*span,
          paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class Particle{
  double left;
  double top;
  double initialLeft;
  double initialTop;
  double sizeFactor;
  Color color;
  ExplodeType type;
  final bool spread;
  int direction;
  double topMax;
  double leftMax;
  double bottomMax;
  double x;
  Particle({this.left,this.top,this.color,this.sizeFactor,this.spread}){
    direction = new Math.Random().nextBool() ? 1: -1;
    initialLeft = left;
    initialTop = top;
    x = new Math.Random().nextInt(1000)/1000.0;
    leftMax = direction ==1?(left + 150*x):left-200*x;
    topMax = top-150;
    bottomMax = initialTop+150;
  }
  advance(double span,bool stage,double height){
    if(spread) {
      left = initialLeft * (1 - span) + leftMax * span;
      top = initialTop + 50 * span +
          100 * Math.sin(Math.pi / 2 + 2 * span * Math.pi);
    } else {
      top = initialTop*(1-span) + height*span;
    }
  }
}
enum ExplodeType{
  Spread,
  Drop
}

