import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'color_palette.dart';

class Bar {
  final double height;
  final Color color;
  final double dx;
  final double dy;

  Bar(this.height, this.color, this.dx, this.dy);

  factory Bar.empty() => new Bar(0.0, Colors.transparent, 0.0, 0.0);
  /*factory Bar.empty(Random random) {
    return new Bar(
      0.0,
      ColorPalette.primary.random(random),
    );

  }*/

  factory Bar.random(Random random) {
    return new Bar(
      //random.nextDouble() * 400.0,
      500.0,
      ColorPalette.primary.random(random),
      800.0, //Testing
      500.0, //Testing
    );
  }


  static Bar lerp(Bar begin, Bar end, double t) {
    return new Bar(
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
      lerpDouble(begin.dx, end.dx, t),
      lerpDouble(begin.dy, end.dy, t),
    );
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
}

class BarChartPainter extends CustomPainter {
  static const barWidth = 32.0;
  static const barHeight = 32.0;

  BarChartPainter(Animation<Bar> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<Bar> animation;

  @override
  void paint(Canvas canvas, Size size) {

    final bar = animation.value;
    /*
    final paint = new Paint()
      ..color = bar.color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      new Rect.fromLTWH(
          (size.width - barWidth) / 2.0,
          (size.height - bar.height),
          barWidth,
          barHeight
      ),
      paint,
    );
    */

    final Paint circlePaint = new Paint()
      ..isAntiAlias = true
      ..strokeWidth = 4.0
      ..color = bar.color
      ..style = PaintingStyle.fill;

    final radius = 20.0;
    final centerOffset = new Offset((size.width ) / 2.0, (size.height - bar.height) - (2.0 * radius) );

    canvas.drawCircle(centerOffset, radius, circlePaint);
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}