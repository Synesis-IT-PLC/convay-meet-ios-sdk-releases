Pod::Spec.new do |s|
  s.name             = 'ConvayMeetSDK'
  s.version = '1.0.1'
  s.summary          = 'Convay Meet SDK for iOS'
  s.description      = <<-DESC
    Convay Meet SDK for iOS allows you to integrate video conferencing capabilities
    into your iOS applications. The SDK includes all necessary dependencies bundled
    in the XCFramework, making it easy to integrate.
  DESC
  s.homepage         = 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Convay' => 'support@convay.org' }
  s.source           = { 
    :http => "https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases/download/ios-sdk-#{s.version}/ConvayMeetSDK-#{s.version}.xcframework.zip",
    :type => 'zip'
  }
  s.platform         = :ios, '13.0'
  s.ios.deployment_target = '13.0'
  s.requires_arc     = true
  s.vendored_frameworks = 'ConvayMeetSDK.xcframework'
  s.preserve_paths = 'ConvayMeetSDK.xcframework'
  s.public_header_files = 'ConvayMeetSDK.xcframework/**/Headers/*.h'
  
  # Framework search paths - CocoaPods will automatically extract the zip
  s.xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/ConvayMeetSDK"',
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/ConvayMeetSDK/ConvayMeetSDK.xcframework/ios-arm64/ConvayMeetSDK.framework/Headers" "${PODS_ROOT}/ConvayMeetSDK/ConvayMeetSDK.xcframework/ios-arm64_x86_64-simulator/ConvayMeetSDK.framework/Headers"',
    'OTHER_LDFLAGS' => '$(inherited) -framework "ConvayMeetSDK"'
  }
  
  # Note: All dependencies (React Native, WebRTC, Giphy, etc.) are bundled
  # in the ConvayMeetSDK.xcframework, so no additional pod dependencies are needed.
end

