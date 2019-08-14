package com.flutter_google_cast_plugin;

import android.util.Log;

import com.google.android.gms.cast.framework.CastContext;
import com.google.android.gms.cast.framework.CastState;
import com.google.android.gms.cast.framework.CastStateListener;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

public class CastStateStreamHandler implements EventChannel.StreamHandler {
    private static final String TAG = "CastState";

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final EventChannel channel = new EventChannel(registrar.messenger(), "flutter_google_cast_plugin.CastState");
        channel.setStreamHandler(new CastStateStreamHandler());
        Log.i(TAG, "registered plugin");
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink sink) {
        Log.d(TAG, "onListen");

        // store sink reference
        eventSink = sink;

        // listen for cast state updates
        CastContext context = CastContext.getSharedInstance();
        context.addCastStateListener(castStateListener);

        // synchonize last state
        lastState = context.getCastState();
        sink.success(lastState);
    }

    @Override
    public void onCancel(Object o) {
        Log.d(TAG, "onCancel");

        // stop listening
        CastContext context = CastContext.getSharedInstance();
        context.removeCastStateListener(castStateListener);

        // remove sink reference
        eventSink = null;
    }

    private int lastState = CastState.NO_DEVICES_AVAILABLE;
    private EventChannel.EventSink eventSink;

    private CastStateListener castStateListener = new CastStateListener() {
        @Override
        public void onCastStateChanged(int newState) {
            Log.v(TAG, "castStateListener newState="+newState);

            lastState = newState;
            if (eventSink != null)
                eventSink.success(newState);
        }
    };
}
