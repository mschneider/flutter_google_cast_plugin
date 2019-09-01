//
//  SessionManagerMethodCallHandler.swift
//  flutter_google_cast_plugin
//
//  Created by Maximilian Schneider on 28.08.19.
//

import Foundation
import GoogleCast

public class SessionManagerMethodCallHandler : NSObject {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_google_cast_plugin.SessionManager", binaryMessenger: registrar.messenger())
        
            channel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                // Note: this method is invoked on the UI thread.
                print("SessiongManager onMethodCall: \(call.method) \(String(describing: call.arguments))")
                
                switch call.method {
                case "showMediaRouteChooserDialog":
                    showMediaRouteChoserDialog()
                case "endCurrentSession":
                    endCurrentSession()
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
    }
    
    static func showMediaRouteChoserDialog() {
        DispatchQueue.main.async {
            GCKCastContext.sharedInstance().presentCastDialog()
        }
    }

    static func endCurrentSession() {
        DispatchQueue.main.async {
            GCKCastContext.sharedInstance().sessionManager.endSessionAndStopCasting(true)
        }
    }
}
