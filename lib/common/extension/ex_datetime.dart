import 'package:intl/intl.dart';

/// 扩展日期时间
extension ExDateTime on DateTime {
  /// 格式化日期 yyyy-MM-dd
  String toDateString({String format = 'yyyy-MM-dd'}) =>
      DateFormat(format).format(this);

  /// 本地时间
  String toLocalString({String format = 'yyyy-MM-dd hh:mm'}) =>
      DateFormat(format).format(toLocal());
}
