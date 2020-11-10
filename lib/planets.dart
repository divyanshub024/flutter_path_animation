import 'dart:ui' as UI;

import 'package:flutter/material.dart';

class Planets extends StatefulWidget {
  @override
  _PlanetsState createState() => _PlanetsState();
}

class _PlanetsState extends State<Planets> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _controller1;
  AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
      appBar: AppBar(
        title: Text('Planets'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            return Center(
              child: CustomPaint(
                painter: AtomPaint(
                  value: _controller.value,
                  value1: _controller1.value,
                  value2: _controller2.value,
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          _controller.reset();
          _controller1.reset();
          _controller2.reset();
          _controller.repeat();
          _controller1.repeat();
          _controller2.repeat();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}

class AtomPaint extends CustomPainter {
  AtomPaint({
    this.value,
    this.value1,
    this.value2,
  });

  final double value, value1, value2;

  Paint _axisPaint = Paint()
    ..color = const Color(0xFFE6E6E6)
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0, 0), 20.0, Paint()..color = Colors.yellow);
    drawAxis(value, canvas, 60, Paint()..color = Colors.grey);
    drawAxis(value1, canvas, 100, Paint()..color = Colors.brown);
    drawAxis(value2, canvas, 140, Paint()..color = Colors.blueAccent);
    drawAxis(value, canvas, 180, Paint()..color = Colors.redAccent);
    drawAxis(value1, canvas, 220, Paint()..color = Colors.lightGreen);
    drawAxis(value2, canvas, 260, Paint()..color = Colors.purpleAccent);
  }

  drawAxis(double value, Canvas canvas, double radius, Paint paint) {
    var firstAxis = getCirclePath(radius);
    canvas.drawPath(firstAxis, _axisPaint);
    UI.PathMetrics pathMetrics = firstAxis.computeMetrics();
    for (UI.PathMetric pathMetric in pathMetrics) {
      var calculation = pathMetric.length * value;
      if (calculation.toInt() == 0 || calculation.toInt() < 0) {
        return;
      }
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length).position;
        canvas.drawCircle(offset, 12.0, paint);
      } catch (e) {}
    }
  }

  Path getCirclePath(double radius) =>
      Path()..addOval(Rect.fromCircle(center: Offset(0, 0), radius: radius));

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
