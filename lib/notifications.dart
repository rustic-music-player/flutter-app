import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rustic/state/media_bloc.dart';

import 'api/api.dart';

class NotificationsService {
  FlutterLocalNotificationsPlugin notificationsPlugin;

  NotificationsService() {
    notificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> setup() async {
    var androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    var settings = InitializationSettings(androidSettings, null);
    await notificationsPlugin.initialize(settings);
  }

  void showNotification(Api api, Playing playing) async {
    if (playing.track == null) {
      notificationsPlugin.cancel(0);
    } else {
      var imagePath = await api.getLocalCoverart(playing.track);
      var androidSpecifics = AndroidNotificationDetails(
          'playing', 'Playing', 'Currently Playing',
          styleInformation: MediaStyleInformation(),
          largeIcon: FilePathAndroidBitmap(imagePath),
          visibility: NotificationVisibility.Public);
      var platformSpecifics = NotificationDetails(androidSpecifics, null);
      notificationsPlugin.show(
          0, playing.track.title, playing.track.artist.name, platformSpecifics);
    }
  }
}
