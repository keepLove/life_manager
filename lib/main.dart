import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:life_manager/bean/life_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final List<LifeTimeBean> _listTime = <LifeTimeBean>[];

  @override
  void initState() {
    _initLifeTime();
    super.initState();
  }

  /// 初始化时间列表
  void _initLifeTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> lifeTimeString = sharedPreferences.getStringList("life_time");
    List<LifeTimeBean> list = lifeTimeString
        ?.map((time) => time == null
            ? null
            : LifeTimeBean.fromJson(jsonDecode(time) as Map<String, dynamic>))
        ?.toList();
    if (list != null && list.isNotEmpty) {
      setState(() {
        _listTime.clear();
        _listTime.addAll(list);
      });
    }
  }

  /// 保存时间列表
  void _saveLifeTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> listString =
        _listTime.map((e) => jsonEncode(e.toJson())).toList();
    sharedPreferences.setStringList("life_time", listString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _listTime.length == 0
          ? new Center(
              child: new Text(
                '您还没有添加时间哦！！',
                style: new TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            )
          : new ListView.builder(
              itemCount: _listTime.length,
              itemBuilder: (context, index) {
                return new CommemorationWidget(timeBean: _listTime[index]);
              },
              padding: const EdgeInsets.all(16.0),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _incrementCounter() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime.now())
        .then((date) {
      print(date);
      setState(() {
        _listTime.add(new LifeTimeBean(0, date.millisecondsSinceEpoch, null));
      });
      _saveLifeTime();
    }, onError: (error) {
      print(error);
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text('选择错误。')));
    });
  }
}

/// 纪念日
class CommemorationWidget extends StatelessWidget {
  final LifeTimeBean timeBean;

  const CommemorationWidget({Key key, @required this.timeBean})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeBean.millisecondsSinceEpoch);
    Duration diffTime = DateTime.now().difference(dateTime).abs();
    return new ListTile(
      title: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new Text(
              '距${dateTime.year}年${dateTime.month}月${dateTime.day}日已有${diffTime.inDays + 1}天',
              style: new TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            margin: EdgeInsets.only(bottom: 10.0),
          ),
          timeBean.detail == null || timeBean.detail.isEmpty
              ? new Container(
                  height: 0,
                )
              : new Text(
                  '${timeBean.detail}',
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey[400]),
                ),
          new Divider(),
        ],
      ),
    );
  }
}
