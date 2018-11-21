import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'color_palette.dart';

class Bar {

  final Color color;
  final double dx;
  final double dy;
  final radius = 20.0;


  Bar(this.color, this.dx, this.dy);

  //Method that returns a transparent object at (0.0 , 0.0) point.
  //factory Bar.empty() => new Bar(Colors.transparent, 0.0, 0.0);
  factory Bar.empty() {
    final random = new Random();
    return new Bar(ColorPalette.primary.random(random), 0.0, 20.0);
  }

  factory Bar.now(double y) {
    final random = new Random();
    return new Bar(ColorPalette.primary.random(random), 0.0, y);
  }

  //Method that returns a random color object at (0.0 , 500.0) point.
  factory Bar.random() {
    final random = new Random();
    double nextdy = 0.0;
    while (nextdy <= 140 ){
      nextdy = random.nextDouble() * 620; //El 640 representa el size height 700 menos 3 veces el radius 20.
    }

    return new Bar(
      ColorPalette.primary.random(random),
      100.0, //Testing
      nextdy, //Testing
    );
  }

  //Static method that returns the lerp of begin and end object.
  static Bar lerp(Bar begin, Bar end, double t) {
    return new Bar(
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
  final Animation<Bar> animation;


  BarChartPainter(Animation<Bar> animation)
      : animation = animation,
        super(repaint: animation);


  @override
  void paint(Canvas canvas, Size size) {

    final bar = animation.value;

    final Paint circlePaint = new Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..color = bar.color
      ..style = PaintingStyle.fill;

    final double x = size.width / 2.0 ;//+ bar.dx;
    final double y = (size.height - bar.dy);

    final centerOffset = new Offset(x, y);

    canvas.drawCircle(centerOffset, bar.radius, circlePaint);
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      new Rect.fromLTRB(
          -200.0, 0.0, 200.0, 100.0
      ),
      new Paint()
        ..color = new Color(0xFF0099FF)
        ..style = PaintingStyle.stroke
    );
  }

  @override
  bool shouldRepaint(Sky oldDelegate) {
    return false;
  }
}