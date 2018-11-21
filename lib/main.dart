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
  int dy = 0;
  int y = 0;


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


    ani = new CurvedAnimation(parent: animationC, curve: Curves.bounceIn);
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


  void refreshB(){
    setState(() {
      bouncings = 0;
    });
  }

  void changeData() {
    setState(() {

      Bar begin = new Bar.empty();
      Bar end = new Bar.random();
      y = (end.dy).toInt();

      dy = tween.evaluate(animationC).dy.toInt();
/*

      if((bouncings > 0) && dy <= 80.0 && dy > 20.0) {
        begin = new Bar.now(dy);
      }
*/
      if ((bouncings == 0) || dy <= 150.0 && dy >= 0.0) {

        bouncings++;
        tween = new BarTween(begin, end);
        animationC.animateWith(simulation2);

      }


    });
  }

  static BorderSide createBorderSide(BuildContext context, { Color color, double width: 3.0 }) {
    assert(width != null);
    return new BorderSide(
      color: color ?? Theme.of(context).dividerColor,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bouncings: $bouncings'),
      ),

      body: new GestureDetector(
        onTap: changeData,

        child: new Column(
          children: <Widget>[
            new Container(

              //padding: const EdgeInsets.only(top: 100.0), //Push container to the bottom
              height: 620.0,
              child: new Column(
                children: <Widget>[

                  new CustomPaint(
                    size: new Size(300.0, 617.0),
                    painter: new BarChartPainter(tween.animate(animationC)),
                  ),


                  new Row(children: <Widget>[
                    //No sirve de nada ahorita.
                  ],),

/*
                  new CustomPaint(
                    size: new Size(300.0, 0.0),
                    painter: new Sky(),
                  ),
*/
                ],
              ),

              decoration: new BoxDecoration(
                border: new Border(
                  bottom: createBorderSide(context, color: color),
                ),
              ),


            ),



            //new Text('.', style: new TextStyle(color: Colors.transparent)),
            //new Text('.', style: new TextStyle(color: Colors.transparent)),
            //new Text('.', style: new TextStyle(color: Colors.transparent)),
            //new Text('.', style: new TextStyle(color: Colors.transparent)),
            //new Text('dy: $dy'),
            //new Text('Bouncings: $bouncings'),
            //new Text('Y: $y'),
          ],
        ),


      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: refreshB,
      ),

    );
  }
}