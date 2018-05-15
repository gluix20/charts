import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'bar.dart';

void main() {
  runApp(new MaterialApp(home: new ChartPage()));
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => new ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {

  AnimationController animationC;
  Animation<double> ani;
  AnimationStatus aniStatus;

  int bouncings = 0;
  Duration dur;
  double dy = 0.0;
  double y = 0.0;

  //ScrollSpringSimulation simulation;
  GravitySimulation simulation2;

  BarTween tween;

  final Color color;

  @override
  void initState() {
    super.initState();

    dur = new Duration(milliseconds: 400);//Duration of the animationController

    animationC = new AnimationController(
      duration: dur,
      vsync: this,
    );

    simulation2= new GravitySimulation(
      -19.8, // acceleration, pixels per second per second
      0.0, // starting position, pixels
      1.0, // ending position, pixels
      6.0, // starting velocity, pixels per second
      //It was so lucky to find the 4.0 velocity, with more it does not work!
      //Have to try with more height
      //The original gravity and velocity was -9.8 and 4.0
    );


    ani = new CurvedAnimation(parent: animationC, curve: Curves.easeIn);
    //Review if ani is only used here to eliminate until know exactly what help provides.

    ani.addStatusListener((status) {
      aniStatus = status;
    });



    //It is not used.
    /*simulation = ScrollSpringSimulation(
      SpringDescription(
        mass: 2.0,
        stiffness: 1.0,
        damping: 0.2,
      ),
      1.0, // starting position, pixels
      400.0, // ending position, pixels
      0.0, // starting velocity, pixels per second
    );
    */

    tween = new BarTween(new Bar.empty(), new Bar.empty());
    //animationC.animateWith(simulation2);


    //animationC.forward();
  }


  @override
  void dispose() {
    animationC.dispose();
    super.dispose();
  }


  void changeData() {
    setState(() {


      Bar end = new Bar.random();
      y = (end.dy);

      dy = tween.evaluate(animationC).dy;
      if (dy <= 50.0 && dy >= 0.0) {

        bouncings++;
        tween = new BarTween(new Bar.empty(), end);
        animationC.animateWith(simulation2);
      }


    });
  }

  static BorderSide createBorderSide(BuildContext context, { Color color, double width: 0.0 }) {
    assert(width != null);
    return new BorderSide(
      color: color ?? Theme.of(context).dividerColor,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new GestureDetector(
        onTap: changeData,
        child: new Container(

          //padding: const EdgeInsets.only(top: 100.0), //Push container to the bottom
          height: 750.0,
          child: new Column(
            children: <Widget>[
              new CustomPaint(

                size: new Size(100.0, 700.0),
                painter: new BarChartPainter(tween.animate(animationC)),
              ),



              new Row(children: <Widget>[
              //No sirve de nada ahorita.
              ],),


              new Text('Bouncings: $bouncings'),
              new Text('Y: $y'),

              ],
            ),

            decoration: new BoxDecoration(
              border: new Border(
                bottom: createBorderSide(context, color: color),
              ),
            ),

          ),
      ),


    );
  }
}