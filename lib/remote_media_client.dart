import 'dart:async';
import 'package:flutter/services.dart';

enum RepeatMode { off, all, single, allAndShuffle }

enum StreamType { invalid, none, buffered, live }

class MediaInfo {
  String contentId;
  String contentType;
  Object customData;
  String entity;
  Map<String, dynamic> metadata;
  StreamType streamType;

  MediaInfo(this.contentId);
}

class MediaLoadRequestData {
  List<int> activeTrackIds;
  bool autoplay;
  String credentials;
  String credentialsType;
  int currentTime;
  Object customData;
  MediaInfo mediaInfo;
  double playbackRate;
  MediaQueueData queueData;
}

class MediaQueueData {
  List<MediaQueueItem> items;
  String name;
  RepeatMode repeatMode;
}

class MediaQueueItem {
  bool autoplay;
  MediaInfo mediaInfo;
  int startIndex;
  int startTime;

  MediaQueueItem(this.mediaInfo);
}

class RemoteMediaClient {
  static const MethodChannel _channel =
      const MethodChannel('flutter_google_cast_plugin.RemoteMediaClient');

  static Future<Map> load(MediaLoadRequestData mediaLoadRequestData) async {
    final Map result =
        await _channel.invokeMethod('load', mediaLoadRequestData);
    return result;
  }

  static Future<Map> play() async {
    final Map result = await _channel.invokeMethod('play');
    return result;
  }
}
