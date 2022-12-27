import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:skillogue/utils/backend/misc_backend.dart';

/*final messaging = FirebaseMessaging.instance;

class Notifications {
  //static final Notifications _notificationsMessage = Notifications._internal();
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /*factory Notifications(){
    return _notificationsMessage;
  }
  Notifications._internal();*/

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = IOSInitializationSettings(requestSoundPermission: true);


    const initSettings =
    InitializationSettings(android: androidSetting, iOS: iosSetting);

    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }


  void addNotification(
      String title,
      String body,
      int endTime,
      {
        String sound = '',
        String channel = 'default',
      }) async {
    tzData.initializeTimeZones();

    final scheduleTime =
    tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    // #3
    var soundFile = sound.replaceAll('.mp3', '');

    final notificationSound =
    sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);
    final androidDetail = AndroidNotificationDetails(
        channel,
        channel,
        playSound: true,
        sound: notificationSound
    );
    final iosDetail = sound == ''
        ? null
        : IOSNotificationDetails(presentSound: true, sound: sound);

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
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
*/
