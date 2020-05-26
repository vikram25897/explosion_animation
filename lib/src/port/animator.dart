import 'dart:math';

import 'package:explosion_animation/src/port/particle.dart';
import 'package:explosion_animation/src/port/utils.dart';
import 'package:flutter/cupertino.dart';

const double END_VALUE = 1.4;
const int DEFAULT_DURATION = 0x400;
double X = Utils.dp2Px(5).toDouble();
double Y = Utils.dp2Px(20).toDouble();
double V = Utils.dp2Px(2).toDouble();
double W = Utils.dp2Px(1).toDouble();
class ExplosionAnimator {
  Paint mPaint;
  List<Particle> mParticles;
  Rect mBound;
  bool isStarted = false;

  ExplosionAnimator(Rect bound) {
    mPaint = new Paint();
    mPaint.style = PaintingStyle.fill;
    mBound = bound;
    int partLen = 15;
    mParticles = [];
    Random random = new Random(DateTime
        .now()
        .millisecondsSinceEpoch);
    for (int i = 0; i < partLen; i++) {
      for (int j = 0; j < partLen; j++) {
        mParticles.add(generateParticle(Color.fromARGB(
            255,
            random.nextInt(255),
            random.nextInt(255),
            random.nextInt(255)), random));
      }
    }
  }

  Particle generateParticle(Color color, Random random) {
    Particle particle = new Particle();
    particle.color = color;
    particle.radius = V;
    if (random.nextDouble() < 0.2) {
      particle.baseRadius = V + ((X - V) * random.nextDouble());
    } else {
      particle.baseRadius = W + ((V - W) * random.nextDouble());
    }
    double nextFloat = random.nextDouble();
    particle.top = mBound.height * ((0.18 * random.nextDouble()) + 0.2);
    particle.top = nextFloat < 0.2 ? particle.top : particle.top +
        ((particle.top * 0.2) * random.nextDouble());
    particle.bottom = (mBound.height * (random.nextDouble()) - 0.5) * 1.8;
    double f = nextFloat < 0.2 ? particle.bottom : nextFloat < 0.8 ? particle
        .bottom * 0.6 : particle.bottom * 0.3;
    particle.bottom = f;
    particle.mag = 4.0 * particle.top / particle.bottom;
    particle.neg = (-particle.mag) / particle.bottom;
    f = mBound.center.dx + (Y * (random.nextDouble()) - 0.5);
    particle.baseCx = f;
    particle.cx = f;
    f = mBound.center.dy + (Y * (random.nextDouble()) - 0.5);
    particle.baseCy = f;
    particle.cy = f;
    particle.life = END_VALUE / 10 * random.nextDouble();
    particle.overflow = 0.4 * random.nextDouble();
    particle.alpha = 1;
    return particle;
  }

  draw(Canvas canvas, double t) {
    if (!isStarted) {
      return;
    }
    for (Particle particle in mParticles) {
      particle.advance(t);
      if (particle.alpha > 0) {
        mPaint.color = particle.color.withOpacity(particle.alpha);
        canvas.drawCircle(
            Offset(particle.cx-100, particle.cy), particle.radius, mPaint);
      }
    }
  }
}