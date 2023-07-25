import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'index.dart';

/// 本地消息服务
class NoticeService extends GetxService {
  static NoticeService get to => Get.find();

  final _local = FlutterLocalNotificationsPlugin();
  final _channel = const AndroidNotificationChannel(
    '闪忆消息通知',
    '闪忆消息通知',
    importance: Importance.max,
  );

  @override
  void onInit() {
    super.onInit();
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const androidSettings = AndroidInitializationSettings(
      "logo",
    );
    _local.initialize(
      const InitializationSettings(
        iOS: iOSSettings,
        android: androidSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse value) {
        if (value.payload == null) {
          return;
        }
        final uri = Uri.tryParse(value.payload ?? '');
        openUri(uri!);
      },
    );
  }

  // 打开 uri, /chat?uid=$uid&type=$type
  Future<void> openUri(Uri uri) async {
    final paths = uri.pathSegments;
    final params = uri.queryParameters;
    if (paths.isEmpty || paths[0] != "chat") {
      return;
    }
    final uid = params["uid"];
    final type = params["type"];
    if (uid == null || type == null) {
      return;
    }
    onChat(uid, int.parse(type));
  }

  Future<void> show(
      {required String title, required String body, String? payload}) async {
    final id = DateTime.now().millisecondsSinceEpoch >> 10;
    final details = NotificationDetails(
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
    await _local.show(id, title, body, details, payload: payload);
  }

  void checkPermission() async {
    if (GetPlatform.isIOS) {
      await _local
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    if (GetPlatform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }
}
