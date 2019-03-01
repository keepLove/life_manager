import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'package:life_manager/screen/commemoration/commemoration_screen.dart';
import 'package:life_manager/model/life_time.dart';
import 'package:life_manager/utils/life_bean_sp_util.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _title = "My Life";
  DateTime _currentDate = DateTime.now();
  List<LifeTimeBean> _currentLifeTimeBean;
  EventList<LifeTimeBean> _markedDateMap = EventList();
  bool _isToday = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _statusBarHeight = 0;

  @override
  void initState() {
    super.initState();
    _statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
    _getMarkedDate();
  }

  /// 获取标记数据
  void _getMarkedDate() {
    LifeBeanUtil.getAllLifeTime().then((list) {
      EventList<LifeTimeBean> eventList = EventList();
      list.forEach((bean) {
        eventList.add(
            DateTime.fromMillisecondsSinceEpoch(bean.millisecondsSinceEpoch),
            bean);
      });
      setState(() {
        _markedDateMap = eventList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
              tooltip: "today",
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _currentDate = DateTime.now();
                  _isToday = true;
                  _title = "${_currentDate.year}年${_currentDate.month}月";
                });
              }),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: "commemoration",
                      child: ListTile(
                        leading: Icon(Icons.favorite_border),
                        title: Text("纪念日"),
                      )),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                      value: "schedule",
                      child: ListTile(
                        leading: Icon(Icons.loyalty),
                        title: Text("备忘日程"),
                      )),
                ],
            onSelected: _popupMenuSelect,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _getCalendar(),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Text(
              _getToDayDateTime(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child:
                (_currentLifeTimeBean == null || _currentLifeTimeBean.isEmpty)
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            "没有日程",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : _getSchedule(),
          ),
        ],
      ),
      drawer: _getDrawer(),
    );
  }

  /// getSchedule
  Widget _getSchedule() {
    return ListView.builder(
      itemCount: _currentLifeTimeBean.length,
      itemBuilder: (context, index) {
        LifeTimeBean lifeTimeBean = _currentLifeTimeBean[index];
        if (lifeTimeBean.type == 0) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                    ),
                    Text(
                      "${lifeTimeBean.title}纪念日",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        }
        return Container();
      },
      padding: EdgeInsets.symmetric(horizontal: 20.0),
    );
  }

  /// getCalendar
  Widget _getCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: CalendarCarousel<LifeTimeBean>(
        locale: "zh",
        // 显示边框
        daysHaveCircularBorder: true,
        // 选中的边框颜色
        selectedDayBorderColor: Colors.transparent,
        // 选中的按钮颜色
        selectedDayButtonColor: _isToday ? Colors.red : Colors.blue[300],
        // 当前的颜色
        todayBorderColor: Colors.red,
        todayButtonColor: Colors.transparent,
        todayTextStyle: TextStyle(
          fontSize: 14.0,
          color: _isToday ? Colors.white : Colors.red,
        ),
        // 星期左右日期样式
        weekendTextStyle: TextStyle(
          color: Colors.black38,
          fontSize: 14.0,
        ),
        // 星期上方的样式
        weekdayTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
        weekDayFormat: WeekdayFormat.narrow,
        weekDayMargin: EdgeInsets.only(top: 20.0),
        minSelectedDate: DateTime(1960),
        maxSelectedDate: DateTime(2050),
        // 不显示头部widget
        showHeader: false,
        // 标记位
        markedDatesMap: _markedDateMap,
        markedDateIconBuilder: (bean) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            height: 6.0,
            width: 6.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          );
        },
        staticSixWeekFormat: true,
        height: 340.0,
        // 选中的日期
        selectedDateTime: _currentDate,
        onDayPressed: (DateTime date, List<LifeTimeBean> list) {
          print(date.toString());
          print(list.toString());
          this.setState(() {
            _currentDate = date;
            _currentLifeTimeBean = list;
            _isToday = _dateTimeEqual(DateTime.now(), date);
          });
        },
        onCalendarChanged: (dateTime) {
          setState(() {
            _title = "${dateTime.year}年${dateTime.month}月";
          });
        },
      ),
    );
  }

  /// getDrawer
  Widget _getDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: _statusBarHeight,
            color: Colors.blue,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: ListTile(
              leading: Icon(Icons.calendar_view_day),
              title: Text(
                "跳转到指定日期",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
                _jumpDateTime();
              },
            ),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }

  /// popupMenu选中事件
  void _popupMenuSelect(String action) async {
    switch (action) {
      case "commemoration":
        final result = await Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new CommemorationScreen()),
        );
        print("navigator commemorate：$result");
        _getMarkedDate();
        break;
      case "schedule":
        break;
    }
  }

  /// 距离当前多少天
  String _getToDayDateTime() {
    if (_dateTimeEqual(_currentDate, DateTime.now())) {
      return "今天  ${_currentDate.year}年${_currentDate.month}月${_currentDate.day}日";
    }
    Duration duration = _currentDate.difference(DateTime.now());
    if (duration.isNegative) {
      return "${duration.inDays.abs()}天前  ${_currentDate.year}年${_currentDate.month}月${_currentDate.day}日";
    }
    return "${duration.inDays.abs()}天后  ${_currentDate.year}年${_currentDate.month}月${_currentDate.day}日";
  }

  /// 比较两个时间是否吻合
  bool _dateTimeEqual(DateTime dateTime, DateTime dateTime2) {
    return dateTime2.year == dateTime.year &&
        dateTime2.month == dateTime.month &&
        dateTime2.day == dateTime.day;
  }

  /// 跳转到指定日期
  void _jumpDateTime() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 100),
            lastDate: DateTime(DateTime.now().year + 100))
        .then((date) {
      if (date != null) {
        setState(() {
          _currentDate = date;
          _isToday = _dateTimeEqual(DateTime.now(), date);
          _title = "${_currentDate.year}年${_currentDate.month}月";
        });
      }
    }, onError: (error) {
      print(error);
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text('选择错误')));
    });
  }
}
