import 'package:flutter/material.dart';
import 'package:rustic/views/servers/servers.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rustic',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.deepOrangeAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: Scaffold(
          appBar: AppBar(title: Text('Add Server')),
          body: Container(padding: EdgeInsets.all(16), child: AddServer())),
    );
  }
}
