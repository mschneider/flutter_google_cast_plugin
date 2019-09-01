//
//  RemoteMediaClientMethodCallHandler.swift
//  flutter_google_cast_plugin
//
//  Created by Maximilian Schneider on 28.08.19.
//
import Flutter
import Foundation
import GoogleCast

public class RemoteMediaClientMethodCallHandler : NSObject {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_google_cast_plugin.RemoteMediaClient", binaryMessenger: registrar.messenger())
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            print("RemoteMediaClient onMethodCall: \(call.method) \(String(describing: call.arguments))")
            
            switch call.method {
            case "load":
                load(call.arguments)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    static func load(_ arguments: Any?) {
        let currentSession = GCKCastContext.sharedInstance().sessionManager.currentSession
        if (currentSession?.connectionState != GCKConnectionState.connected) {
            print("RemoteMediaClient load: currentCastSession not connected, ignore attempt to load")
            return
        }

        let argsDict = arguments! as! [String:Any]
        let deserializer = MediaLoadRequestDataDeserializer(with: argsDict)
        let mediaLoadRequest = deserializer.deserialize()
        currentSession!.remoteMediaClient!.loadMedia(with: mediaLoadRequest)
    }

    class MediaInfoDeserializer {
        private var serialized: [String:Any]
        
        public init(with arguments: [String:Any]) {
            self.serialized = arguments
        }
        
        public func deserialize() -> GCKMediaInformation {
            let builder = GCKMediaInformationBuilder(contentURL: URL(string: serialized["contentId"] as! String)!)
            
            if let contentType = serialized["contentType"] as? String {
                builder.contentType = contentType
            }
            if let entity = serialized["entity"] as? String {
                builder.entity = entity
            }
            if let streamType = serialized["streamType"] as? String {
                switch streamType {
                case "StreamType.none":
                    builder.streamType = GCKMediaStreamType.none
                case "StreamType.buffered":
                    builder.streamType = GCKMediaStreamType.buffered
                case "StreamType.live":
                    builder.streamType = GCKMediaStreamType.live
                default:
                    builder.streamType = GCKMediaStreamType.unknown
                    print("can't assign unknown streamType '\(streamType)'")
                }
            }
            
            return builder.build()
        }
    }
    
    class MediaQueueItemDeserializer {
        private var serialized: [String:Any]
        
        public init(with arguments: [String:Any]) {
            self.serialized = arguments
        }
        
        public func deserialize() -> GCKMediaQueueItem {
            let builder = GCKMediaQueueItemBuilder()
            
            builder.mediaInformation = MediaInfoDeserializer(with: serialized["mediaInfo"] as! [String:Any]).deserialize()
            
            if let autoplay = serialized["autoplay"] as? Bool {
                builder.autoplay = autoplay
            }
            if let playbackDuration = serialized["playbackDuration"] as? Double {
                builder.playbackDuration = playbackDuration
            }
            if let startTime = serialized["startTime"] as? Double {
                builder.startTime = startTime
            }
            
            return builder.build()
        }
    }
    
    class MediaQueueDataDeserializer {
        private var serialized: [String:Any]
        
        public init(with arguments: [String:Any]) {
            self.serialized = arguments
        }
        
        public func deserialize() -> GCKMediaQueueData {
            let builder = GCKMediaQueueDataBuilder.init(queueType: GCKMediaQueueType.generic)
            
            if let items = serialized["items"] as? [[String:Any]] {
                
                var deserializedItems: [GCKMediaQueueItem] = []
                
                for item in items {
                    deserializedItems.append(MediaQueueItemDeserializer.init(with: item).deserialize())
                }
                
                builder.items = deserializedItems
            }
            if let name = serialized["name"] as? String {
                builder.name = name
            }
            if let repeatMode = serialized["repeatMode"] as? String {
                switch repeatMode {
                case "RepeatMode.off":
                    builder.repeatMode = GCKMediaRepeatMode.off
                case "RepeatMode.all":
                    builder.repeatMode = GCKMediaRepeatMode.all
                case "RepeatMode.single":
                    builder.repeatMode = GCKMediaRepeatMode.single
                case "RepeatMode.allAndShuffle":
                    builder.repeatMode = GCKMediaRepeatMode.allAndShuffle
                default:
                    print("can't assign unknown repeatMode '\(repeatMode)'")
                }
            }
            
            return builder.build()
        }
    }
    
    class MediaLoadRequestDataDeserializer {
        
        private var serialized: [String:Any]
        
        public init(with arguments: [String:Any]) {
            self.serialized = arguments
        }
        
        public func deserialize() -> GCKMediaLoadRequestData {
            let builder = GCKMediaLoadRequestDataBuilder()
            
            if let autoplay = serialized["autoplay"] as? Bool {
                builder.autoplay = autoplay as NSNumber
            }
            if let credentials = serialized["credentials"] as? String {
                builder.credentials = credentials
            }
            if let credentialsType = serialized["credentialsType"] as? String {
                builder.credentialsType = credentialsType
            }
            if let currentTime = serialized["currentTime"] as? Int64 {
                builder.startTime = TimeInterval(integerLiteral: currentTime)
            }
            if let mediaInfo = serialized["mediaInfo"] as? [String:Any] {
                builder.mediaInformation = MediaInfoDeserializer(with: mediaInfo).deserialize()
            }
            if let playbackRate = serialized["playbackRate"] as? Float {
                builder.playbackRate = playbackRate
            }
            if let queueData = serialized["queueData"] as? [String:Any] {
                builder.queueData = MediaQueueDataDeserializer(with: queueData).deserialize()
            }
            
            return builder.build();
        }
    }
}

