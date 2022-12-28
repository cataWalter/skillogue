import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class LocalNoticeService {
  // Singleton of the LocalNoticeService
  static final LocalNoticeService _notificationService =
  LocalNoticeService._internal();

  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory LocalNoticeService() {
    return _notificationService;
  }
  LocalNoticeService._internal();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('logoNotification');

    const initSettings =
    InitializationSettings(android: androidSetting);

    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  void addNotification(
      String title,
      String body,
      int endTime, {
        String sound = '',
        String channel = 'default',
      }) async {
    tzData.initializeTimeZones();

    final scheduleTime =
    tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);


    final soundFile = sound.replaceAll('.mp3', '');
    final notificationSound =
    sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);

    final androidDetail = AndroidNotificationDetails(
        channel, // channel Id
        channel, // channel Name
        playSound: true,
        sound: notificationSound
        );

    final noticeDetail = NotificationDetails(
      android: androidDetail,
    );

    // #4
    const id = 0;

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  void cancelAllNotification() {
    _localNotificationsPlugin.cancelAll();
  }
}
