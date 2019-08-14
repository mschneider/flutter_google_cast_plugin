package com.flutter_google_cast_plugin;

import android.util.Log;
import androidx.mediarouter.app.MediaRouteChooserDialog;
import com.google.android.gms.cast.framework.CastContext;
import com.google.android.gms.cast.framework.CastSession;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class SessionManagerMethodCallHandler implements MethodChannel.MethodCallHandler {
    private static final String TAG = "SessionManager";

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_google_cast_plugin.SessionManager");
        channel.setMethodCallHandler(new SessionManagerMethodCallHandler());
        Log.i(TAG, "registered plugin");
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall: " + call.method + " " + call.arguments);

        if (call.method.equals("showMediaRouteChooserDialog")) {
            showMediaRouteChoserDialog();
        } else if (call.method.equals("endCurrentSession")) {
            endCurrentSession((Boolean)call.arguments);
        } else {
            result.notImplemented();
        }
    }

    protected void showMediaRouteChoserDialog() {
        MediaRouteChooserDialog dialog = new MediaRouteChooserDialog(FlutterGoogleCastPlugin.getContext(), FlutterGoogleCastPlugin.getTheme().getCastDialogTheme());
        dialog.setRouteSelector(CastContext.getSharedInstance().getMergedSelector());
        dialog.show();
    }

    protected void endCurrentSession(Boolean b) {
        CastContext.getSharedInstance().getSessionManager().endCurrentSession(b);
    }

}
