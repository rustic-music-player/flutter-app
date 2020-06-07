import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rustic/media_bloc.dart';

class NotificationsService {
  final String host;
  FlutterLocalNotificationsPlugin notificationsPlugin;

  NotificationsService({this.host}) {
    notificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> setup() async {
    var androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = InitializationSettings(androidSettings, null);
    await notificationsPlugin.initialize(settings);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/media-thumbnail-$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void showNotification(Playing playing) async {
    if (playing.track == null) {
      notificationsPlugin.cancel(0);
    } else {
      var imagePath = await _downloadAndSaveFile(
          'http://$host${playing.track.coverart}', playing.track.cursor);
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
