import 'package:flutter/material.dart';

class Lines extends StatefulWidget {
  @override
  _LinesState createState() => _LinesState();
}

class _LinesState extends State<Lines> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lines'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              print(_controller.value);
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                    child: CustomPaint(
                      painter: LinePainter(progress: _controller.value),
                      size: Size(double.maxFinite, 100),
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: RaisedButton(
              child: Text('Animated'),
              onPressed: () {
                _controller.reset();
                _controller.forward();
              },
            ),
          )
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double progress;

  LinePainter({this.progress});

  Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, size.height / 2);
    print('${size.width * progress}, ${size.height / 2}');
    path.lineTo(size.width * progress, size.height / 2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

//class LinePainter extends CustomPainter {
//  Paint _paint = Paint()
//    ..color = Colors.black
//    ..strokeWidth = 4.0
//    ..style = PaintingStyle.stroke
//    ..strokeJoin = StrokeJoin.round;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    Path path = createLinePath(size);
//    canvas.drawPath(path, _paint);
//  }
//
//  Path createLinePath(Size size) {
//    var path = Path();
//    var x = 0.0;
//    var y = size.height;
//    path.moveTo(x, y);
//    for (int i = 0; i < 3; i++) {
//      x += size.height / 2;
//      path.lineTo(x, 0.0);
//      x += size.height / 2;
//      path.lineTo(x, size.height);
//    }
//    return path;
//  }
//
//  @override
//  bool shouldRepaint(CustomPainter oldDelegate) {
//    return false;
//  }
//}
