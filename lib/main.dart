import 'package:flutter/material.dart';
import 'package:path_animation/circles.dart';
import 'package:path_animation/lines.dart';
import 'package:path_animation/path_morph.dart';
import 'package:path_animation/polygon.dart';
import 'package:path_animation/spiral.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> screens = {
      'Lines': Lines(),
      'Circles': Circles(),
      'Polygon': Polygon(),
      'Spiral': Spiral(),
      'PathMorph': PathMorph(),
    };

    List<Widget> children = [];
    screens.forEach((k, v) {
      children.add(
        ListTile(
          title: Text(k),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => v),
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Flutter path animation')),
      body: ListView(
        children: children,
      ),
    );
  }
}
