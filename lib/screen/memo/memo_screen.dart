import 'package:flutter/material.dart';

import 'package:life_manager/model/life_time.dart';
import 'package:life_manager/screen/memo/add_day_screen.dart';
import 'package:life_manager/utils/life_bean_sp_util.dart';

/// 备忘录
class MemoScreen extends StatefulWidget {
  final String title = "备忘录";

  @override
  _MemoState createState() => _MemoState();
}

class _MemoState extends State<MemoScreen> {
  final List<LifeTimeBean> _listTime = <LifeTimeBean>[];

  @override
  void initState() {
    _initLifeTime();
    super.initState();
  }

  /// 初始化时间列表
  void _initLifeTime() async {
    LifeBeanUtil.getMemoData().then((list) {
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
                '您还没有备忘录哦！！',
                style: new TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            )
          : new ListView.builder(
              itemCount: _listTime.length,
              itemBuilder: (context, index) {
                return new CommemorationItemWidget(
                  timeBean: _listTime[index],
                  itemCallback: _itemCallback,
                );
              },
              padding: const EdgeInsets.all(16.0),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDay,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _itemCallback(int type, LifeTimeBean bean) {
    if (type == 0) {
      _initLifeTime();
    } else {
      setState(() {
        _listTime.remove(bean);
      });
      LifeBeanUtil.save(_listTime);
    }
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

/// type: 0是编辑  1是删除
typedef ItemCallback = void Function(int type, LifeTimeBean value);

/// 纪念日item
class CommemorationItemWidget extends StatelessWidget {
  final LifeTimeBean timeBean;
  final ItemCallback itemCallback;

  const CommemorationItemWidget(
      {Key key, @required this.timeBean, @required this.itemCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeBean.millisecondsSinceEpoch);
    return new ListTile(
      title: Card(
        color: Colors.blue,
        semanticContainer: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "${dateTime.year}-${dateTime.month}-${dateTime.day}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "${timeBean.title ?? timeBean.detail}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => _itemClick(context),
    );
  }

  void _itemClick(BuildContext context) {
    showDialog<LifeTimeBean>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text("编辑"),
                onPressed: () {
                  Navigator.pop(context);
                  _editLifeTimeBean(context);
                },
              ),
              SimpleDialogOption(
                child: Text("删除"),
                onPressed: () {
                  Navigator.pop(context);
                  itemCallback(1, timeBean);
                },
              )
            ],
          );
        });
  }

  /// 编辑
  void _editLifeTimeBean(BuildContext context) async {
    final result =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddDayScreen(
        editLifeTimeBean: timeBean,
      );
    }));
    if (result == 1) {
      itemCallback(0, timeBean);
    }
  }
}
