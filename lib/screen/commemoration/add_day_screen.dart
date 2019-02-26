import 'package:flutter/material.dart';
import 'package:life_manager/model/life_time.dart';
import 'package:life_manager/utils/life_bean_sp_util.dart';

/// 添加纪念日
class AddDayScreen extends StatefulWidget {
  final String title = "Add Day Of Commemoration";

  @override
  State<StatefulWidget> createState() {
    return _AddDayState();
  }
}

class _AddDayState extends State<AddDayScreen> {
  DateTime _dateTime = DateTime.now();
  String _commemorationTitle;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextStyle _textStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.blue,
  );

  final BoxBorder _border = Border.all(
    width: 0.2,
    style: BorderStyle.solid,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("请描述你的纪念日:", style: _textStyle),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              decoration: BoxDecoration(border: _border),
              child: TextField(
                onChanged: (message) {
                  _commemorationTitle = message;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.0),
                  hintText: "例如结婚纪念日",
                  hintStyle: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[400],
                  ),
                ),
                style: _textStyle,
                keyboardAppearance: Brightness.dark,
              ),
            ),
            Text("请选择日期:", style: _textStyle),
            FlatButton(
              onPressed: _selectDay,
              child: Text(
                "${_dateTime.year}-${_dateTime.month}-${_dateTime.day}",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                ),
              ),
              color: Colors.white,
              colorBrightness: Brightness.dark,
              splashColor: Colors.blue,
              padding: EdgeInsets.all(10.0),
              shape: _border,
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: _addDay,
                child: Text(
                  "提交",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                color: Colors.blue,
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 选择日期
  void _selectDay() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((date) {
      print(date);
      setState(() {
        _dateTime = date;
      });
    }, onError: (error) {
      print(error);
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text('选择错误')));
    });
  }

  void _addDay() {
    if (_commemorationTitle == null || _commemorationTitle.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("请描述你的纪念日")));
      return;
    }
    LifeBeanUtil.saveLifeTime(
        LifeTimeBean(0, _dateTime.millisecondsSinceEpoch, _commemorationTitle));
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("成功")));
    // 1成功
    Navigator.of(context).pop(1);
  }
}
