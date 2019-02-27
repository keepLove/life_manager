import 'dart:convert';

import 'package:life_manager/model/life_time.dart';
import 'package:life_manager/resources/shared_preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifeBeanUtil {
  LifeBeanUtil._();

  /// 获取全部的列表
  static Future<List<LifeTimeBean>> getAllLifeTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> lifeTimeString = sharedPreferences
        .getStringList(SharedPreferencesKeys.lifeTimeBeanListKey);
    // json转换
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

  /// 保存
  static void save(List<LifeTimeBean> listTime) async {
    // 按时间排序
    listTime.sort(
            (a, b) =>
            b.millisecondsSinceEpoch.compareTo(a.millisecondsSinceEpoch));
    // 生成json
    List<String> listString =
    listTime.map((e) => jsonEncode(e.toJson())).toList();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(
        SharedPreferencesKeys.lifeTimeBeanListKey, listString);
  }

  /// 添加时间列表
  static void addLifeTime(LifeTimeBean lifeTimeBean) async {
    List<LifeTimeBean> listTime = await getAllLifeTime();
    listTime.add(lifeTimeBean);
    save(listTime);
  }

  /// 删除
  static void deleteLifeTime(LifeTimeBean lifeBean) async {
    List<LifeTimeBean> list = await getAllLifeTime();
    list.remove(lifeBean);
    save(list);
  }

  /// 编辑
  static void editLifeTimeBean(LifeTimeBean lifeBean) async {
    List<LifeTimeBean> list = await getAllLifeTime();
    final length = list.length;
    for (int i = 0; i < length; i++) {
      final LifeTimeBean value = list[i];
      if (value.lastUpdateMilliseconds == lifeBean.lastUpdateMilliseconds) {
        lifeBean.lastUpdateMilliseconds = DateTime
            .now()
            .millisecondsSinceEpoch;
        list[i] = lifeBean;
        break;
      }
    }
    save(list);
  }
}
