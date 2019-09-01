import Flutter
import GoogleCast
import UIKit

public class SwiftFlutterGoogleCastPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    DispatchQueue.main.async {
        let discoveryCriteria = GCKDiscoveryCriteria(applicationID: kGCKDefaultMediaReceiverApplicationID)
        let options = GCKCastOptions(discoveryCriteria: discoveryCriteria)
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        GCKCastContext.setSharedInstanceWith(options)
    }

    CastStateStreamHandler.register(with: registrar)
    SessionManagerMethodCallHandler.register(with: registrar)
    RemoteMediaClientMethodCallHandler.register(with: registrar)
  }
}

