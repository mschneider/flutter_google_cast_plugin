#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_google_cast_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Plugin that wraps the native Google Cast SDK'
  s.description      = <<-DESC
Plugin that wraps the native Google Cast SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.frameworks =
    "Accelerate",
    "AudioToolbox",
    "AVFoundation",
    "CFNetwork",
    "CoreBluetooth",
    "CoreData",
    "CoreGraphics",
    "CoreMedia",
    "CoreText",
    "Foundation",
    "MediaAccessibility",
    "MediaPlayer",
    "QuartzCore",
    "Security",
    "SystemConfiguration",
    "UIKit",
    "GoogleCast"

  s.preserve_path = "Frameworks/GoogleCastSDK-4.4.4/*"
  s.vendored_frameworks = 'Frameworks/GoogleCastSDK-4.4.4/GoogleCast.framework'

  s.ios.deployment_target = '9.0'
end

