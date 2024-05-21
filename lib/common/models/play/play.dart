import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/common.dart';

part 'play.g.dart';

typedef GameSummary = ({String gameName, int playCount, String totalPoints});

@JsonSerializable()
class PlayRecordModel {
  final int code;
  final String message;
  @JsonKey(name: 'log')
  final List<PlayLog> logs;

  const PlayRecordModel(
      {required this.code, required this.message, required this.logs});

  factory PlayRecordModel.fromJson(Map<String, dynamic> json) =>
      _$PlayRecordModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayRecordModelToJson(this);

  /// 取得近 [period] 天的點數
  ///
  /// 回傳格式為 `總點數+總免費點數P`
  String? getPeriodPoints(int period) {
    final valueFormat = NumberFormat("#,###");
    final filteredLogs = logs.where((element) {
      if (period == -1) return true;
      final rawSourceTime = element.initTime.date;
      final sourceTime = DateTime.fromMillisecondsSinceEpoch(rawSourceTime);
      final targetTime = DateTime.now().subtract(Duration(days: period));
      return sourceTime.isAfter(targetTime);
    });
    if (filteredLogs.isEmpty) return null;
    var totalPoint = 0;
    var totalfreep = 0;
    for (var log in filteredLogs) {
      totalPoint += log.price.toInt();
      totalfreep += log.freep.toInt();
    }
    return '${valueFormat.format(totalPoint)}+${valueFormat.format(totalfreep)}P';
  }

  List<GameSummary> getGameSummaries(int period) {
    Map<String, ({int playCount, int point, int freep})> map = {};

    final filteredLogs = logs.where((element) {
      if (period == -1) return true;
      final rawSourceTime = element.initTime.date;
      final sourceTime = DateTime.fromMillisecondsSinceEpoch(rawSourceTime);
      final targetTime = DateTime.now().subtract(Duration(days: period));
      return sourceTime.isAfter(targetTime);
    });
    if (filteredLogs.isEmpty) return [];

    for (var log in filteredLogs) {
      if (!map.containsKey(log.mid)) {
        map[log.mid] = (
          playCount: 1,
          point: log.price.toInt(),
          freep: log.freep.toInt(),
        );
      } else {
        map[log.mid] = (
          playCount: map[log.mid]!.playCount + 1,
          point: map[log.mid]!.point + log.price.toInt(),
          freep: map[log.mid]!.freep + log.freep.toInt()
        );
      }
    }
    List<GameSummary> summaries = [];
    final valueFormat = NumberFormat("#,###");
    for (var record in map.entries) {
      summaries.add((
        gameName: record.key,
        playCount: record.value.playCount,
        totalPoints:
            "${valueFormat.format(record.value.point)}+${valueFormat.format(record.value.freep)}P",
      ));
    }
    return summaries;
  }
}

@JsonSerializable()
class PlayLog {
  final int cid;
  final bool disbool;
  final bool done;
  final double freep;
  @JsonKey(name: 'inittime')
  final InitTime initTime;
  final String mid;
  final double price;
  final String sid;
  final String status;
  final String time;
  final String uid;
  @JsonKey(name: '_id')
  final UnderscoreId id;

  const PlayLog(
      {required this.cid,
      required this.disbool,
      required this.done,
      required this.freep,
      required this.initTime,
      required this.mid,
      required this.price,
      required this.sid,
      required this.status,
      required this.time,
      required this.uid,
      required this.id});

  factory PlayLog.fromJson(Map<String, dynamic> json) =>
      _$PlayLogFromJson(json);
  Map<String, dynamic> toJson() => _$PlayLogToJson(this);
}
