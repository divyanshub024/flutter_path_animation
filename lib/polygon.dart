import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class Polygon extends StatefulWidget {
  @override
  _PolygonState createState() => _PolygonState();
}

class _PolygonState extends State<Polygon> with SingleTickerProviderStateMixin {
  double sides = 3.0;
  bool showDots = false, showPath = true;
  AnimationController _controller;

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
        title: Text('Polygon'),
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
                        painter: PolygonPainter(
                          sides: sides,
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
              child: Text('Sides'),
            ),
            Slider(
              value: sides,
              min: 3.0,
              max: 10.0,
              label: sides.toInt().toString(),
              divisions: 7,
              onChanged: (value) {
                setState(() {
                  sides = value;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PolygonPainter extends CustomPainter {
  PolygonPainter({
    this.sides,
    this.progress,
    this.showPath,
    this.showDots,
  });

  final double sides;
  final double progress;
  bool showDots, showPath;

  final Paint _paint = Paint()
    ..color = Colors.purple
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = createPath(sides.toInt(), 100);
    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath =
        pathMetric.extractPath(0.0, pathMetric.length * progress);
    if (showPath) {
      canvas.drawPath(extractPath, _paint);
    }
    if (showDots) {
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length).position;
        canvas.drawCircle(offset, 8.0, Paint());
      } catch (e) {}
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path createPath(int sides, double radius) {
    var path = Path();
    var angle = (math.pi * 2) / sides;
    path.moveTo(radius * math.cos(0.0), radius * math.sin(0.0));
    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(angle * i);
      double y = radius * math.sin(angle * i);
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }
}
