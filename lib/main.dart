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

  int dataSet = 5;
  int iRandom;
  Duration dur;

  ScrollSpringSimulation simulation;
  GravitySimulation simulation2;

  BarTween tween;

  @override
  void initState() {
    super.initState();

    iRandom = random.nextInt(1000);//Random integer
    dur = new Duration(milliseconds: 400);//Duration of the animationController


    animationC = new AnimationController(
      duration: dur,
      vsync: this,
    );


    //ani = new CurvedAnimation(parent: animationC, curve: Curves.easeIn);
    //Review if ani is only used here to eliminate until know exactly what help provides.




    simulation = ScrollSpringSimulation(
      SpringDescription(
        mass: 2.0,
        stiffness: 1.0,
        damping: 0.2,
      ),
      1.0, // starting position, pixels
      400.0, // ending position, pixels
      0.0, // starting velocity, pixels per second
    );

    simulation2= new GravitySimulation(
      -10.5, // acceleration, pixels per second per second
      0.0, // starting position, pixels
      300.0, // ending position, pixels
      4.0, // starting velocity, pixels per second
    );


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


      //animationC.animateWith(simulation2);
      tween = new BarTween(new Bar.empty(), new Bar.random(random));
      //tween = new BarTween(tween.evaluate(animationC), new Bar.random(random));


      dataSet++;
      iRandom = random.nextInt(1000);


      animationC.forward(from: 0.0);
      
      animationC.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationC.reverse();
      } 

      /*else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }*/
    });



      //CAMBIO #002 Rollbacked
      //this(repaint: animationC);
      //tween = new BarTween(tween.evaluate(animationC),new Bar.empty());
      //animationC.forward(from: 0.0);

      //CAMBIO #001 Rollbacked
      //animationC.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    int dura = animationC.duration.inMilliseconds;
    return new Scaffold(
      body: new Container(
        padding: const EdgeInsets.only(top: 500.0),
        child: new Column(
          children: <Widget>[
            new CustomPaint(
              size: new Size(400.0, 100.0),
              painter: new BarChartPainter(tween.animate(animationC)),
            ),
            new Text('$dataSet'),
            new Text('$iRandom'),
            new Text('$dura'),
          ],
        ),
      ),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}