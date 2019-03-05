import 'package:flutter/material.dart';

import 'package:life_manager/model/life_time.dart';
import 'package:life_manager/utils/life_bean_sp_util.dart';

/// 添加或编辑备忘录
class AddDayScreen extends StatefulWidget {
  final String title = "备忘录";
  final LifeTimeBean editLifeTimeBean;

  AddDayScreen({Key key, this.editLifeTimeBean}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddDayState();
  }
}

class _AddDayState extends State<AddDayScreen> {
  DateTime _dateTime;
  String _memoDetail;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();

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
  void initState() {
    super.initState();
    if (widget.editLifeTimeBean != null) {
      _controller.text = widget.editLifeTimeBean.detail;
      _memoDetail = _controller.text;
      _dateTime = DateTime.fromMillisecondsSinceEpoch(
          widget.editLifeTimeBean.millisecondsSinceEpoch);
    } else {
      _dateTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              Text("纪录下你的心事吧:", style: _textStyle),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                decoration: BoxDecoration(border: _border),
                child: TextField(
                  controller: _controller,
                  onChanged: (message) {
                    _memoDetail = message;
                  },
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  maxLength: 200,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.0),
                    hintText: "纪录下你的心情吧",
                    hintStyle: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  style: _textStyle,
                  keyboardAppearance: Brightness.dark,
                ),
              ),
//              Text("请选择日期:", style: _textStyle),
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
      ),
    );
  }

  /// 选择日期
  void _selectDay() {
    showDatePicker(
            context: context,
            initialDate: _dateTime,
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((date) {
      if (date != null) {
        setState(() {
          _dateTime = date;
        });
      }
    }, onError: (error) {
      print(error);
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text('选择错误')));
    });
  }

  void _addDay() {
    if (_memoDetail == null || _memoDetail.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("请描述下你的心情吧")));
      return;
    }
    if (widget.editLifeTimeBean == null) {
      LifeTimeBean lifeTimeBean = LifeTimeBean(
          type: LifeTimeBeanType.memo_type,
          millisecondsSinceEpoch: _dateTime.millisecondsSinceEpoch,
          detail: _memoDetail);
      LifeBeanUtil.addLifeTime(lifeTimeBean);
    } else {
      widget.editLifeTimeBean.millisecondsSinceEpoch =
          _dateTime.millisecondsSinceEpoch;
      widget.editLifeTimeBean.detail = _memoDetail;
      LifeBeanUtil.editLifeTimeBean(widget.editLifeTimeBean);
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("成功")));
    // 1成功
    Navigator.of(context).pop(1);
  }
}
