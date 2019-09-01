# flutter_google_cast_plugin

Plugin that wraps the native [Google Cast SDK](https://developers.google.com/cast/)

*Warning:* this plugin is work in progress and does not support all use
cases of the Cast API yet. If your use case is not supported, please
reach out.

## Getting Started

The Plugin provides access to the standard UI components of the native
SDK as well as the underlying functionality in case you want to build
your own UI. Events are exposed as Streams and Blocs to allow
integration into widgets.

#### Connection

Here is a simple example for a google cast button that changes it's
appearance based on the connection state and opens the native "Cast to"
dialog for connecting to a cast device.

```
BlocBuilder(
    bloc: castStateBloc,
    builder: (context, state) {
      return IconButton(
          icon: Icon(state == CastState.connected
              ? Icons.cast_connected
              : Icons.cast),
          onPressed: SessionManager.showMediaRouteChooserDialog);
    });
```

#### Playing Media

In order to play back media on your cast device a highly customizable
media load request has to be configured. [Google's official
documentation](https://developers.google.com/android/reference/com/google/android/gms/cast/MediaLoadRequestData) is a good starting point to discover the detailled configuration options. Following is an example that displays a single video looping.

```
var mediaInfo = MediaInfo(url);
mediaInfo.contentType = 'video/mp4';
mediaInfo.streamType = StreamType.buffered;

var mediaQueueItem = MediaQueueItem(mediaInfo);
mediaQueueItem.autoplay = true;

var mediaQueueData = MediaQueueData([mediaQueueItem]);
mediaQueueData.repeatMode = RepeatMode.single;

var mediaLoadRequestData = MediaLoadRequestData();
mediaLoadRequestData.autoplay = true;
mediaLoadRequestData.queueData = mediaQueueData;

RemoteMediaClient.load(mediaLoadRequestData)

```

#### Setup the build

*iOS*

The Cast SDK uses a combination of WiFi, Bluetooth and the microphone to discover and connect new cast devices to your app. Some of theses features are only available to subscribed members of the apple developer program, therefore you won't be able to build your app using a personal team to code sign.

You need to add the following capabilities to your
`ios/Runner/Runner.entitlements`

```
<dict>
	<key>com.apple.developer.networking.wifi-info</key>
	<true/>
</dict>
```

You also need to add the following permission requests to your `ios/Runner/Info.plist`

```
<dict>
	<key>NSBluetoothPeripheralUsageDescription</key>
	<string>${PRODUCT_NAME} uses Bluetooth to discover nearby Cast devices.</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>${PRODUCT_NAME} uses microphone access to listen for ultrasonic tokens when pairing with nearby Cast devices.</string>
</dict>
```

*Android*

The Cast SDK expects your app to define a few resources in order
to configure the SDK and to define the theme of the native UI
elements.

1. Add your `app_id` under `android/app/src/main/res/values/strings.xml`:

```
<resources>
    <string name="app_id">4F8B3483</string>
</resources>
```

2. Create an OptionsProvider for the cast SDK. See
   [DefaultCastOptionsProvider.java](example/android/app/src/main/java/com/flutter_google_cast_plugin_example/DefaultCastOptionsProvider.java) for an example.

3. Define a theme for the Cast SDK UI Elements in `android/app/src/main/res/values/styles.xml`

```
<resources>
    <style name="CastDialogTheme" parent="Theme.AppCompat.NoActionBar">
        <item name="colorPrimary">@android:color/darker_gray</item>
        <item name="colorPrimaryDark">@android:color/black</item>
        <item name="colorAccent">@android:color/background_light</item>
        <item name="android:textColorPrimary">@android:color/white</item>
        <item name="android:textColorSecondary">@android:color/black</item>
        <item name="windowNoTitle">true</item>
    </style>
</resources>
```

4. Create a FlutterGoogleCastTheme, see [DefaultFlutterGoogleCastTheme](example/android/app/src/main/java/com/flutter_google_cast_plugin_example/DefaultFlutterGoogleCastTheme.java) for an example.

5. Initialize the SDK in your `MainActivity.java`

```
@Override
protected void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  FlutterGoogleCastPlugin.setContext(this);
  FlutterGoogleCastPlugin.setTheme(new DefaultFlutterGoogleCastTheme());
  GeneratedPluginRegistrant.registerWith(this);
}
```

