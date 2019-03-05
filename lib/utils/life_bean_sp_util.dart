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

  /// 获取纪念日数据
  static Future<List<LifeTimeBean>> getCommemorationData() async {
    List<LifeTimeBean> lifeTimeList = <LifeTimeBean>[];
    getAllLifeTime().then((list) {
      for (var value in list) {
        if (value.type == LifeTimeBeanType.commemoration_type) {
          lifeTimeList.add(value);
        }
      }
    });
    return lifeTimeList;
  }

  /// 获取备忘录数据
  static Future<List<LifeTimeBean>> getMemoData() async {
    List<LifeTimeBean> lifeTimeList = <LifeTimeBean>[];
    getAllLifeTime().then((list) {
      for (var value in list) {
        if (value.type == LifeTimeBeanType.memo_type) {
          lifeTimeList.add(value);
        }
      }
    });
    return lifeTimeList;
  }

  /// 保存
  static void save(List<LifeTimeBean> listTime) async {
    // 按时间排序
    listTime.sort(
        (a, b) => b.millisecondsSinceEpoch.compareTo(a.millisecondsSinceEpoch));
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
    for (var value in list) {
      if (value == lifeBean) {
        list.remove(value);
      }
    }
    save(list);
  }

  /// 编辑
  static void editLifeTimeBean(LifeTimeBean lifeBean) async {
    List<LifeTimeBean> list = await getAllLifeTime();
    final length = list.length;
    for (int i = 0; i < length; i++) {
      final LifeTimeBean value = list[i];
      if (value.lastUpdateMilliseconds == lifeBean.lastUpdateMilliseconds) {
        lifeBean.lastUpdateMilliseconds = DateTime.now().millisecondsSinceEpoch;
        list[i] = lifeBean;
        break;
      }
    }
    save(list);
  }
}
