import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class Circles extends StatefulWidget {
  @override
  _CirclesState createState() => _CirclesState();
}

class _CirclesState extends State<Circles> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double circles = 5.0;
  bool showDots = false, showPath = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _controller.value = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circles'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, snapshot) {
                    return Center(
                      child: CustomPaint(
                        painter: CirclesPainter(
                          circles: circles,
                          progress: _controller.value,
                          showDots: showDots,
                          showPath: showPath,
                        ),
                      ),
                    );
                  }),
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
              value: _controller.value,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _controller.value = value;
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
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
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
    double angle = 2 * math.pi / n;
    for (int i in range) {
      double x = radius * math.cos(i * angle);
      double y = radius * math.sin(i * angle);
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    }
    return path;
  }

  @override
  bool shouldRepaint(CirclesPainter oldDelegate) {
    return true;
  }
}
