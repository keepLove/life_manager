import 'package:flutter/material.dart';

import 'package:life_manager/screen/commemoration/commemoration_screen.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

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
  EventList<Event> _markedDateMap = EventList();
  bool _isToday = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
//                    const PopupMenuDivider(),
                  ],
              onSelected: (String action) {
                switch (action) {
                  case "commemoration":
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new CommemorationScreen()),
                    );
                    break;
                }
              }),
        ],
      ),
      body: Container(
        margin: new EdgeInsets.symmetric(horizontal: 10.0),
        child: CalendarCarousel<Event>(
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
          showHeader: false,
          markedDatesMap: _markedDateMap,
          selectedDateTime: _currentDate,
          onDayPressed: (DateTime date, List<Event> list) {
            this.setState(() {
              _currentDate = date;
              _isToday = DateTime.now().year == date.year &&
                  DateTime.now().month == date.month &&
                  DateTime.now().day == date.day;
            });
          },
          onCalendarChanged: (dateTime) {
            setState(() {
              _title = "${dateTime.year}年${dateTime.month}月";
            });
          },
        ),
      ),
    );
  }
}
