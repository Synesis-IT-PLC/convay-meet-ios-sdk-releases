Pod::Spec.new do |s|
  s.name             = 'ConvayMeetSDK'
  s.version = '1.0.3'
  s.summary          = 'Convay Meet SDK for iOS'
  s.description      = <<-DESC
    Convay Meet SDK for iOS allows you to integrate video conferencing capabilities
    into your iOS applications. Dependencies are provided via CocoaPods.
  DESC
  s.homepage         = 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Convay' => 'support@convay.org' }
  s.source           = { :git => 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases.git', :tag => s.version }
  s.platform         = :ios, '15.0'
  s.ios.deployment_target = '15.0'
  s.requires_arc     = true
  s.vendored_frameworks = 'Frameworks/ConvayMeetSDK.xcframework'
  s.preserve_paths = 'Frameworks/ConvayMeetSDK.xcframework'
  s.public_header_files = 'Frameworks/ConvayMeetSDK.xcframework/**/Headers/*.h'
  
  # Framework search paths
  s.xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/ConvayMeetSDK/Frameworks"',
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/ConvayMeetSDK/Frameworks/ConvayMeetSDK.xcframework/ios-arm64/ConvayMeetSDK.framework/Headers" "${PODS_ROOT}/ConvayMeetSDK/Frameworks/ConvayMeetSDK.xcframework/ios-arm64_x86_64-simulator/ConvayMeetSDK.framework/Headers"',
    'OTHER_LDFLAGS' => '$(inherited) -framework "ConvayMeetSDK"'
  }
  
  s.dependency 'Giphy', '= 2.2.12'
  s.dependency 'JitsiWebRTC'
end

