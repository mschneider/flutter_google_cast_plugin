package com.flutter_google_cast_plugin;

import android.util.Log;
import com.google.android.gms.cast.MediaLoadRequestData;
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
            load((MediaLoadRequestData) call.arguments);
        } else {
            result.notImplemented();
        }
    }

    protected void load(MediaLoadRequestData mediaLoadRequestData) {
        CastSession currentCastSession = CastContext.getSharedInstance().getSessionManager().getCurrentCastSession();
        if (currentCastSession == null || !currentCastSession.isConnected()) {
            Log.i(TAG, "currentCastSession not connected, ignore attempt to load");
            return;
        }

        currentCastSession.getRemoteMediaClient().load(mediaLoadRequestData);
    }

}
