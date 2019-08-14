package com.flutter_google_cast_plugin;


import java.util.List;
import java.util.LinkedList;
import java.util.Map;
import java.util.HashMap;

import android.provider.MediaStore;
import android.util.Log;

import androidx.arch.core.util.Function;

import com.google.android.gms.cast.MediaInfo;
import com.google.android.gms.cast.MediaQueueData;
import com.google.android.gms.cast.MediaQueueItem;
import com.google.android.gms.cast.MediaLoadRequestData;
import com.google.android.gms.cast.MediaStatus;
import com.google.android.gms.cast.framework.CastContext;
import com.google.android.gms.cast.framework.CastSession;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class RemoteMediaClientMethodCallHandler implements MethodChannel.MethodCallHandler {
    private static final String TAG = "RemoteMediaClient";

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_google_cast_plugin.RemoteMediaClient");
        channel.setMethodCallHandler(new RemoteMediaClientMethodCallHandler());
        Log.i(TAG, "registered plugin");
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall: " + call.method + " " + call.arguments);

        if (call.method.equals("load")) {
            load(call.arguments);
        } else {
            result.notImplemented();
        }
    }

    protected void load(Object arguments) {
        CastSession currentCastSession = CastContext.getSharedInstance().getSessionManager().getCurrentCastSession();
        if (currentCastSession == null || !currentCastSession.isConnected()) {
            Log.i(TAG, "currentCastSession not connected, ignore attempt to load");
            return;
        }

        MediaLoadRequestDataDeserializer mediaLoadRequestDataDeserializer = new MediaLoadRequestDataDeserializer(arguments);
        MediaLoadRequestData mediaLoadRequestData = mediaLoadRequestDataDeserializer.getMediaLoadRequestData();
        currentCastSession.getRemoteMediaClient().load(mediaLoadRequestData);
    }


    public interface ValueDeserializer<K, V> {
        void set(K key, Function<V, Void> setter);
    }

    public class MapDeserializer<K> {
        final Map<K, Object> serializedMap;

        public MapDeserializer(Map<K, Object> serializedMap) {
            this.serializedMap = serializedMap;
        }

        public <V> void deserialize(K key, Function<V, Void> setter) {
            Object serializedValue = serializedMap.get(key);
            if (serializedValue != null)
                setter.apply((V)serializedValue);
        }
    }

    class MediaInfoDeserializer {
        final HashMap<String, Object> serialized;

        public MediaInfoDeserializer(Object serialized) {
            this.serialized = (HashMap<String, Object>)serialized;
        }

        public MediaInfo getMediaInfo() {
            MediaInfo.Builder builder = new MediaInfo.Builder((String)this.serialized.get("contentId"));

            if (serialized.get("contentType") != null) {
                builder.setContentType((String) serialized.get("contentType"));
            }
            if (serialized.get("entity") != null) {
                builder.setContentType((String) serialized.get("entity"));
            }
            if (serialized.get("streamType") != null) {
                switch ((String)serialized.get("streamType")) {
                    case "invalid":
                        builder.setStreamType(MediaInfo.STREAM_TYPE_INVALID);
                        break;
                    case "none":
                        builder.setStreamType(MediaInfo.STREAM_TYPE_NONE);
                        break;
                    case "buffered":
                        builder.setStreamType(MediaInfo.STREAM_TYPE_BUFFERED);
                        break;
                    case "live":
                        builder.setStreamType(MediaInfo.STREAM_TYPE_LIVE);
                        break;
                }
            }

            return builder.build();
        }
    }

    class MediaQueueItemDeserializer {
        final HashMap<String, Object> serialized;

        public MediaQueueItemDeserializer(Object serialized) {
            this.serialized = (HashMap<String, Object>)serialized;
        }

        public MediaQueueItem getMediaQueueItem() {
            MediaInfo mediaInfo = new MediaInfoDeserializer(this.serialized.get("mediaInfo")).getMediaInfo();
            MediaQueueItem.Builder builder = new MediaQueueItem.Builder(mediaInfo);


            if (serialized.get("autoplay") != null) {
                builder.setAutoplay((Boolean) serialized.get("autoplay"));
            }
            if (serialized.get("playbackDuration") != null) {
                builder.setPlaybackDuration((Double) serialized.get("playbackDuration"));
            }
            if (serialized.get("startTime") != null) {
                builder.setStartTime((Double) serialized.get("startTime"));
            }

            return builder.build();
        }
    }

    class MediaQueueDataDeserializer {
        final HashMap<String, Object> serialized;

        public MediaQueueDataDeserializer(Object serialized) {
            this.serialized = (HashMap<String, Object>)serialized;
        }

        public MediaQueueData getMediaQueueData() {
            MediaQueueData.Builder builder = new MediaQueueData.Builder();

            if (serialized.get("items") != null) {
                List<MediaQueueItem> items = new LinkedList<MediaQueueItem>();

                for (Object o : (List<Object>)serialized.get("items")) {
                    items.add(new MediaQueueItemDeserializer(o).getMediaQueueItem());
                }

                builder.setItems(items);
            }
            if (serialized.get("name") != null) {
                builder.setName((String) serialized.get("name"));
            }
            if (serialized.get("repeatMode") != null) {
                switch ((String)serialized.get("repeatMode")) {
                    case "off":
                        builder.setRepeatMode(MediaStatus.REPEAT_MODE_REPEAT_OFF);
                        break;
                    case "all":
                        builder.setRepeatMode(MediaStatus.REPEAT_MODE_REPEAT_ALL);
                        break;
                    case "single":
                        builder.setRepeatMode(MediaStatus.REPEAT_MODE_REPEAT_SINGLE);
                        break;
                    case "allAndShuffle":
                        builder.setRepeatMode(MediaStatus.REPEAT_MODE_REPEAT_ALL_AND_SHUFFLE);
                        break;
                }
            }

            return builder.build();
        }
    }

    class MediaLoadRequestDataDeserializer {
        final HashMap<String, Object> serialized;

        public MediaLoadRequestDataDeserializer(Object serialized) {
            this.serialized = (HashMap<String, Object>)serialized;
        }

        public MediaLoadRequestData getMediaLoadRequestData() {
            MediaLoadRequestData.Builder builder = new MediaLoadRequestData.Builder();

            if (serialized.get("autoplay") != null) {
                builder.setAutoplay((Boolean) serialized.get("autoplay"));
            }
            if (serialized.get("credentials") != null) {
                builder.setCredentials((String) serialized.get("credentials"));
            }
            if (serialized.get("credentialsType") != null) {
                builder.setCredentialsType((String) serialized.get("credentialsType"));
            }
            if (serialized.get("currentTime") != null) {
                builder.setCurrentTime((Long) serialized.get("currentTime"));
            }
            if (serialized.get("mediaInfo") != null) {
                builder.setMediaInfo(new MediaInfoDeserializer(serialized.get("mediaInfo")).getMediaInfo());
            }
            if (serialized.get("playbackRate") != null) {
                builder.setPlaybackRate((Double) serialized.get("playbackRate"));
            }
            if (serialized.get("queueData") != null) {
                builder.setQueueData(new MediaQueueDataDeserializer(serialized.get("queueData")).getMediaQueueData());
            }

            return builder.build();
        }
    }
}
