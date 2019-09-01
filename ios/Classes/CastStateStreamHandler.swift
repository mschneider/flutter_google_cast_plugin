import Flutter
import GoogleCast

public class CastStateStreamHandler: NSObject, FlutterStreamHandler {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel(name: "flutter_google_cast_plugin.CastState", binaryMessenger: registrar.messenger())
    channel.setStreamHandler(CastStateStreamHandler())
  }

  private var lastState = GCKCastState.noDevicesAvailable;
  private var eventSink: FlutterEventSink?

  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
    print("CastState onListen")
    
    // store sink reference
    self.eventSink = eventSink
    
    // listen for cast state updates
    let context = GCKCastContext.sharedInstance()
    NotificationCenter.default.addObserver(self, selector: #selector(onCastStateChanged), name: NSNotification.Name.gckCastStateDidChange, object: GCKCastContext.sharedInstance());
    
    // synchronize last state
    self.lastState = context.castState
    eventSink(self.lastState.rawValue)
    
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("CastState onCancel")
    
    // stop listening
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.gckCastStateDidChange, object: GCKCastContext.sharedInstance())
    
    // remove sink reference
    self.eventSink = nil
    
    return nil
  }
    
    @objc func onCastStateChanged(_: Notification) {
        print("castStateListener newState=\(String(describing:GCKCastContext.sharedInstance().castState.rawValue)) eventSink=\(String(describing:eventSink))")
        
        self.lastState = GCKCastContext.sharedInstance().castState
        eventSink?(self.lastState.rawValue + 1)
    }
}
