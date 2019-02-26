import 'package:json_annotation/json_annotation.dart';

///项目根目录下运行 flutter packages pub run build_runner build
///通过 flutter packages pub run build_runner watch 在项目根目录下运行来启动_watcher_

// user.g.dart 将在我们运行生成命令后自动生成
part 'life_time.g.dart';

///项目根目录下运行 flutter packages pub run build_runner build
///通过 flutter packages pub run build_runner watch 在项目根目录下运行来启动_watcher_
// user.g.dart 将在我们运行生成命令后自动生成

//这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()
class LifeTimeBean {
  int type;
  int millisecondsSinceEpoch;
  String detail;

  LifeTimeBean(this.type, this.millisecondsSinceEpoch, this.detail);

  factory LifeTimeBean.fromJson(Map<String, dynamic> json) =>
      _$LifeTimeBeanFromJson(json);

  Map<String, dynamic> toJson() => _$LifeTimeBeanToJson(this);
}
