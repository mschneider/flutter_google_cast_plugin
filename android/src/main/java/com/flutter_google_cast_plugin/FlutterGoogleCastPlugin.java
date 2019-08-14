package com.flutter_google_cast_plugin;

import android.content.Context;
import android.util.Log;

import com.google.android.gms.cast.framework.CastContext;

import io.flutter.plugin.common.PluginRegistry;

public class FlutterGoogleCastPlugin {
    private static final String TAG = "FlutterGoogleCastPlugin";

    public static void registerWith(PluginRegistry.Registrar registrar) {
        Log.d(TAG, "registering plugin channels");

        CastStateStreamHandler.registerWith(registrar);
        RemoteMediaClientMethodCallHandler.registerWith(registrar);
        SessionManagerMethodCallHandler.registerWith(registrar);
    }

    private static Context context;
    private static FlutterGoogleCastTheme theme;

    public static Context getContext() {
        return context;
    }

    public static void setContext(Context context) {
        CastContext.getSharedInstance(context);
        FlutterGoogleCastPlugin.context = context;
    }

    public static FlutterGoogleCastTheme getTheme() {
        return theme;
    }

    public static void setTheme(FlutterGoogleCastTheme theme) {
        FlutterGoogleCastPlugin.theme = theme;
    }

}
