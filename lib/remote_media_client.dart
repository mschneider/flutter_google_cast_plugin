import 'dart:async';
import 'package:flutter/services.dart';

enum RepeatMode { off, all, single, allAndShuffle }

enum StreamType { invalid, none, buffered, live }

class MediaInfo {
  String contentId;
  String contentType;
  String entity;
  Map<String, dynamic> metadata;
  StreamType streamType;

  MediaInfo(this.contentId);

  Map<String, dynamic> toJson() =>
      {
        "contentId" : contentId,
        "contentType" : contentType,
        "entity" : entity,
        "metadata" : metadata,
        "streamType" : streamType.toString(),
      };
}

class MediaLoadRequestData {
  List<int> activeTrackIds;
  bool autoplay;
  String credentials;
  String credentialsType;
  int currentTime;
  MediaInfo mediaInfo;
  double playbackRate;
  MediaQueueData queueData;

  Map<String, dynamic> toJson() =>
      {
        "activeTrackIds" : activeTrackIds,
        "autoplay" : autoplay,
        "credentials" : credentials,
        "credentialsType" : credentialsType,
        "currentTime" : currentTime,
        "mediaInfo" : mediaInfo?.toJson(),
        "playbackRate" : playbackRate,
        "queueData" : queueData?.toJson()
      };
}

class MediaQueueData {
  List<MediaQueueItem> items;
  String name;
  RepeatMode repeatMode;

  MediaQueueData(this.items);

  Map<String, dynamic> toJson() =>
      {
        "items" : items.map((i) => i.toJson()).toList(),
        "name" : name,
        "repeatMode" : repeatMode.toString()
      };
}

class MediaQueueItem {
  bool autoplay;
  MediaInfo mediaInfo;
  double playbackDuration;
  double startTime;

  MediaQueueItem(this.mediaInfo);

  Map<String, dynamic> toJson() =>
      {
        "autoplay" : autoplay,
        "mediaInfo" : mediaInfo.toJson(),
        "playbackDuration" : playbackDuration,
        "startTime" : startTime
      };
}

class RemoteMediaClient {
  static const MethodChannel _channel =
      const MethodChannel('flutter_google_cast_plugin.RemoteMediaClient');

  static Future<Map> load(MediaLoadRequestData mediaLoadRequestData) async {
    final Map result =
        await _channel.invokeMethod('load', mediaLoadRequestData.toJson());
    return result;
  }

  static Future<Map> loadUrl(String url, String title) {
    var mediaInfo = MediaInfo(url);
    mediaInfo.contentType = 'video/mp4';
    mediaInfo.streamType = StreamType.buffered;
    mediaInfo.metadata = { "title": title };

    var mediaQueueItem = MediaQueueItem(mediaInfo);
    mediaQueueItem.autoplay = true;

    var mediaQueueData = MediaQueueData([mediaQueueItem]);
    mediaQueueData.repeatMode = RepeatMode.single;

    var mediaLoadRequestData = MediaLoadRequestData();
    mediaLoadRequestData.autoplay = true;
    mediaLoadRequestData.queueData = mediaQueueData;

    return load(mediaLoadRequestData);
  }
}
