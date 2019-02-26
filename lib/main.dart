import 'package:flutter/material.dart';
import 'package:life_manager/screen/commemoration/commemoration_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Life',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Life'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
              itemBuilder: (BuildContext context) =>
              <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    value: "screen.commemoration",
                    child: Text('Day Of Commemoration')),
              ],
              onSelected: (String action) {
                switch (action) {
                  case "screen.commemoration":
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new CommemorationScreen()),
                    );
                    break;
                }
              })
        ],
      ),
      body: new Center(
        child: new Text(
          '您还没有添加时间哦！！',
          style: new TextStyle(fontSize: 20.0, color: Colors.grey),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
