import 'package:flutter/material.dart';
import 'package:rustic/api/http.dart';
import 'package:rustic/views/library/library.dart';
import 'package:rustic/views/search/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var api = new HttpApi(baseUrl: 'http://192.168.1.13:8080'); // TODO: get from config
    return MaterialApp(
      title: 'Rustic',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey, accentColor: Colors.deepOrangeAccent, visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: '/',
      routes: {
        '/': (context) => LibraryView(api: api),
        '/search': (context) => SearchView(api: api)
      },
    );
  }
}
