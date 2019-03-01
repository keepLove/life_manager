import 'package:json_annotation/json_annotation.dart';

///项目根目录下运行 flutter packages pub run build_runner build
///通过 flutter packages pub run build_runner watch 在项目根目录下运行来启动_watcher_

// life_time.g.dart 将在我们运行生成命令后自动生成
part 'life_time.g.dart';

//这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()
class LifeTimeBean {
  /// 类型 0是纪念日，显示已过天数
  int type;

  /// 时间戳
  int millisecondsSinceEpoch;

  /// 最后一次更改的时间戳
  int lastUpdateMilliseconds;

  /// 标题
  String title;

  /// 描述
  String detail;

  LifeTimeBean(
      {this.type = LifeTimeBeanType.commemoration_type,
      this.millisecondsSinceEpoch,
      this.title,
      this.detail}) {
    lastUpdateMilliseconds = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifeTimeBean &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          millisecondsSinceEpoch == other.millisecondsSinceEpoch &&
          lastUpdateMilliseconds == other.lastUpdateMilliseconds &&
          title == other.title &&
          detail == other.detail;

  @override
  int get hashCode =>
      type.hashCode ^
      millisecondsSinceEpoch.hashCode ^
      lastUpdateMilliseconds.hashCode ^
      title.hashCode ^
      detail.hashCode;

  @override
  String toString() {
    return 'LifeTimeBean{type: $type, millisecondsSinceEpoch: $millisecondsSinceEpoch, lastUpdateMilliseconds: $lastUpdateMilliseconds, title: $title, detail: $detail}';
  }

  factory LifeTimeBean.fromJson(Map<String, dynamic> json) =>
      _$LifeTimeBeanFromJson(json);

  Map<String, dynamic> toJson() => _$LifeTimeBeanToJson(this);
}

class LifeTimeBeanType {
  LifeTimeBeanType._();

  /// 纪念日类型
  static const int commemoration_type = 0;
}
