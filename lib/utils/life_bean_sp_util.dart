import 'dart:convert';

import 'package:life_manager/model/life_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifeBeanUtil {
  LifeBeanUtil._();

  /// 保存时间列表
  static void saveLifeTime(LifeTimeBean lifeTimeBean) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> lifeTimeString = sharedPreferences.getStringList("life_time");
    List<LifeTimeBean> _listTime = lifeTimeString
        ?.map((time) => time == null
            ? null
            : LifeTimeBean.fromJson(jsonDecode(time) as Map<String, dynamic>))
        ?.toList();
    if (_listTime == null) {
      _listTime = <LifeTimeBean>[];
    }
    _listTime.add(lifeTimeBean);
    List<String> listString =
        _listTime.map((e) => jsonEncode(e.toJson())).toList();
    sharedPreferences.setStringList("life_time", listString);
  }

  /// 获取全部的列表
  static Future<List<LifeTimeBean>> getAllLifeTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> lifeTimeString = sharedPreferences.getStringList("life_time");
    List<LifeTimeBean> list = lifeTimeString
        ?.map((time) => time == null
            ? null
            : LifeTimeBean.fromJson(jsonDecode(time) as Map<String, dynamic>))
        ?.toList();
    if (list == null) {
      list = <LifeTimeBean>[];
    }
    return list;
  }
}
