package com.flutter_google_cast_plugin_example;

import android.os.Bundle;

import com.flutter_google_cast_plugin.FlutterGoogleCastPlugin;
import com.google.android.gms.cast.framework.CastContext;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    FlutterGoogleCastPlugin.setContext(this);
    FlutterGoogleCastPlugin.setTheme(new DefaultFlutterGoogleCastTheme());
    GeneratedPluginRegistrant.registerWith(this);
  }
}
