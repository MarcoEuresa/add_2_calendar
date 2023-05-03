import 'dart:convert';
import 'dart:io';

import 'package:add_2_calendar/src/model/recurrence.dart';

/// Class that holds each event's info.
class Event {
  String title;
  String? description;
  String? location;
  String? timeZone;
  DateTime startDate;
  DateTime endDate;
  bool allDay;

  final IOSParams iosParams;
  final AndroidParams androidParams;
  final Recurrence? recurrence;

  /// Specify a custom location with lat and lon.
  ///
  /// If [iosLocation] is null, it will use [location] instead
  final IOSLocation? iosLocation;

  Event({
    required this.title,
    this.description,
    this.location,
    required this.startDate,
    required this.endDate,
    this.timeZone,
    this.allDay = false,
    this.iosParams = const IOSParams(),
    this.androidParams = const AndroidParams(),
    this.recurrence,
    this.iosLocation,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> params = {
      'title': title,
      'desc': description,
      'location': location,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'timeZone': timeZone,
      'allDay': allDay,
      'recurrence': recurrence?.toJson(),
      'iosLocation': iosLocation?.toJson()
    };

    if (Platform.isIOS) {
      params['alarmInterval'] = iosParams.reminder?.inSeconds.toDouble();
      params['url'] = iosParams.url;
    } else {
      params['invites'] = androidParams.emailInvites?.join(",");
    }

    return params;
  }
}

class AndroidParams {
  final List<String>? emailInvites;

  const AndroidParams({this.emailInvites});
}

class IOSParams {
  //In iOS, you can set alert notification with duration. Ex. Duration(minutes:30) -> After30 min.
  final Duration? reminder;
  final String? url;

  const IOSParams({this.reminder, this.url});
}

class IOSLocation {
  final String? name;
  final double lat;
  final double lon;

  const IOSLocation({this.name = '', required this.lat, required this.lon});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
    };
  }
}
