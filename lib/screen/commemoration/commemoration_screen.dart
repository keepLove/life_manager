import 'package:flutter/material.dart';
import 'package:life_manager/model/life_time.dart';
import 'package:life_manager/screen/commemoration/add_day_screen.dart';
import 'package:life_manager/utils/life_bean_sp_util.dart';

/// 纪念日
class CommemorationScreen extends StatefulWidget {
  final String title = "Day Of Commemoration";

  @override
  _CommemorationWidgetState createState() => _CommemorationWidgetState();
}

class _CommemorationWidgetState extends State<CommemorationScreen> {
  final List<LifeTimeBean> _listTime = <LifeTimeBean>[];

  @override
  void initState() {
    _initLifeTime();
    super.initState();
  }

  /// 初始化时间列表
  void _initLifeTime() async {
    LifeBeanUtil.getAllLifeTime().then((list) {
      setState(() {
        _listTime.clear();
        _listTime.addAll(list);
      });
    });
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
                return new CommemorationItemWidget(timeBean: _listTime[index]);
              },
              padding: const EdgeInsets.all(16.0),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDay,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /// 添加纪念日
  void _addDay() async {
    final result =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddDayScreen();
    }));
    if (result == 1) {
      _initLifeTime();
    }
  }
}

/// 纪念日item
class CommemorationItemWidget extends StatelessWidget {
  final LifeTimeBean timeBean;

  const CommemorationItemWidget({Key key, @required this.timeBean})
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
