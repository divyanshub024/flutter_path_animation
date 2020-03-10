import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class Circles extends StatefulWidget {
  @override
  _CirclesState createState() => _CirclesState();
}

class _CirclesState extends State<Circles> with SingleTickerProviderStateMixin {
  double circles = 5.0;
  double progress = 1.0;
  bool showDots = false, showPath = true;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _controller.addListener(() {
      setState(() {
        progress = _controller.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circles'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Expanded(
                child: Center(
                  child: CustomPaint(
                    painter: CirclesPainter(
                      circles: circles,
                      progress: progress,
                      showDots: showDots,
                      showPath: showPath,
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 0.0),
                child: Text('Show Dots'),
              ),
              Switch(
                value: showDots,
                onChanged: (value) {
                  setState(() {
                    showDots = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 0.0),
                child: Text('Show Path'),
              ),
              Switch(
                value: showPath,
                onChanged: (value) {
                  setState(() {
                    showPath = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text('Circles'),
          ),
          Slider(
            value: circles,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            label: circles.toInt().toString(),
            onChanged: (value) {
              setState(() {
                circles = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text('Progress'),
          ),
          Slider(
            value: progress,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {
              setState(() {
                progress = value;
              });
            },
          ),
          Center(
            child: RaisedButton(
              child: Text('Animate'),
              onPressed: () {
                _controller.reset();
                _controller.forward();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CirclesPainter extends CustomPainter {
  CirclesPainter({this.circles, this.progress, this.showDots, this.showPath});

  final double circles, progress;
  bool showDots, showPath;

  var myPaint = Paint()
    ..color = Colors.purple
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5.0;

  double radius = 80;

  @override
  void paint(Canvas canvas, Size size) {
    var path = createPath();
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * progress);
      if (showPath) {
        canvas.drawPath(extractPath, myPaint);
      }
      if (showDots) {
        try {
          var metric = extractPath.computeMetrics().first;
          final offset = metric.getTangentForOffset(metric.length).position;
          canvas.drawCircle(offset, 8.0, Paint());
        } catch (e) {}
      }
    }
  }

  Path createPath() {
    var path = Path();
    int n = circles.toInt();
    var range = List<int>.generate(n, (i) => i + 1);
    for (int i in range) {
      double x = 2 * math.pi / n;
      double dx = radius * math.cos(i * x);
      double dy = radius * math.sin(i * x);
      path.addOval(Rect.fromCircle(center: Offset(dx, dy), radius: radius));
    }
    return path;
  }

  @override
  bool shouldRepaint(CirclesPainter oldDelegate) {
    return true;
  }
}
