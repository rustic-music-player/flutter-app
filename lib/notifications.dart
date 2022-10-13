import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rustic/state/media_bloc.dart';

import 'api/api.dart';

class NotificationsService {
  FlutterLocalNotificationsPlugin? notificationsPlugin;

  NotificationsService() {
    if (NotificationsService.isSupported) {
      notificationsPlugin = FlutterLocalNotificationsPlugin();
    }
  }

  Future<void> setup() async {
    if (!NotificationsService.isSupported) {
      return;
    }
    var androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    var linuxSettings = LinuxInitializationSettings(defaultActionName: "Open Player");
    var settings = InitializationSettings(android: androidSettings, linux: linuxSettings);
    await notificationsPlugin?.initialize(settings);
  }

  void showNotification(Api api, Playing playing) async {
    if (!NotificationsService.isSupported) {
      return;
    }
    if (playing.track == null) {
      notificationsPlugin?.cancel(0);
    } else {
      var imagePath = await api.getLocalCoverart(playing.track!);
      var androidSpecifics = AndroidNotificationDetails('playing', 'Playing',
          channelDescription: 'Currently Playing',
          ongoing: true,
          styleInformation: MediaStyleInformation(),
          largeIcon: FilePathAndroidBitmap(imagePath),
          visibility: NotificationVisibility.public,
          audioAttributesUsage: AudioAttributesUsage.media);
      var linuxSpecifics =
          LinuxNotificationDetails(suppressSound: true, urgency: LinuxNotificationUrgency.low);
      var platformSpecifics = NotificationDetails(android: androidSpecifics, linux: linuxSpecifics);
      notificationsPlugin?.show(
          0, playing.track?.title, playing.track?.artist?.name, platformSpecifics);
    }
  }

  static final isSupported =
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isLinux || Platform.isMacOS);
}
