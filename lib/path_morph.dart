import 'package:flutter/material.dart';

class PathMorph extends StatefulWidget {
  @override
  _PathMorphState createState() => _PathMorphState();
}

class _PathMorphState extends State<PathMorph> {
  bool isSquare = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Path Morph'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Center(
              child: CustomPaint(
                painter: MyPainter(
                  path: isSquare ? squarePath() : circlePath(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('Square'),
                  onPressed: () {
                    setState(() {
                      isSquare = true;
                    });
                  },
                ),
                RaisedButton(
                  child: Text('Circle'),
                  onPressed: () {
                    setState(() {
                      isSquare = false;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Path circlePath() =>
      Path()..addOval(Rect.fromCircle(center: Offset(0.0, 0.0), radius: 50.0));

  Path squarePath() => Path()
    ..moveTo(-50.0, -50.0)
    ..lineTo(50.0, -50.0)
    ..lineTo(50.0, 50.0)
    ..lineTo(-50.0, 50.0)
    ..close();
}

class MyPainter extends CustomPainter {
  MyPainter({this.path});

  final Path path;

  final Paint _paint = Paint()
    ..color = Colors.purple
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
