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
  final random = new Random();
  AnimationController animationC;
  Animation<double> ani;
  AnimationStatus aniStatus;

  int dataSet = 1;
  int iRandom;
  Duration dur;
  double dy = 0.0;

  //ScrollSpringSimulation simulation;
  GravitySimulation simulation2;

  BarTween tween;

  @override
  void initState() {
    super.initState();

    iRandom = random.nextInt(1000);//Random integer
    dur = new Duration(milliseconds: 50);//Duration of the animationController


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



    //animationC.fling(velocity: 0.1);


    tween = new BarTween(new Bar.empty(), new Bar.random(random));

    animationC.animateWith(simulation2);
    //animationC.forward();
  }

  @override
  void dispose() {
    animationC.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {

      dy = tween.evaluate(animationC).dy;
      if (dy <= 40.0 && dy >= 0.0) {

        dataSet++;
        iRandom = random.nextInt(1000);
        tween = new BarTween(new Bar.empty(), new Bar.random(random));
        animationC.animateWith(simulation2);
      }


    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new GestureDetector(
        onTap: changeData,
        child: new Container(

          padding: const EdgeInsets.only(top: 100.0), //Push container to the bottom

          child: new Column(
            children: <Widget>[
              new CustomPaint(

                size: new Size(100.0, 600.0),
                painter: new BarChartPainter(tween.animate(animationC)),
              ),
              new Row(children: <Widget>[
//No sirve de nada ahorita.
              ],),

                new Text('Bouncings: $dataSet'),
                new Text('Height (fixed for now): $iRandom'),
                new Text('Y: $dy'),

            ],
          ),
        ),
    ),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: changeData,
      ),


    );
  }
}