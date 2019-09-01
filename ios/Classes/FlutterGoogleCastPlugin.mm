#import "FlutterGoogleCastPlugin.h"
#import <flutter_google_cast_plugin/flutter_google_cast_plugin-Swift.h>

@implementation FlutterGoogleCastPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterGoogleCastPlugin registerWithRegistrar:registrar];
}
@end
