import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Photos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _items = ['hello', 'hello2', 'hello23', 'hello5'];

  Future<http.Response> get _refresh =>
      http.get('https://jsonplaceholder.typicode.com/photos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _refresh,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final response = snapshot.data as http.Response;
            final List items = json.decode(response.body);
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => ListTile(
                    title: Text(
                      items[index]['title'],
                    ),
                    subtitle: Text('Album ID is ${items[index]['albumId']}'),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(items[index]['thumbnailUrl']),
                    ),
                  ),
              itemCount: items.length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
