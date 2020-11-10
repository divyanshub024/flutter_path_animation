import 'package:flutter/material.dart';
import 'circles.dart';
import 'lines.dart';
import 'planets.dart';
import 'polygon.dart';
import 'spiral.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      'Planets': Planets(),
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
