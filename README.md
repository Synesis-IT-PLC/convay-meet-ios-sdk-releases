# Convay Meet iOS SDK releases

This repository contains the binaries for the **[Convay Meet]() iOS SDK**. Each
release is tagged in this repository and is composed of following framework:

- ConvayMeetSDK.xcframework

## Using the SDK

The recommended way for using the SDK is by using [CocoaPods](). In order to
do so, add the `ConvayMeetSDK` dependency to your existing `Podfile` or create
a new one following this example:

```
platform :ios, '15.1'

workspace 'ConvayMeetSDKTest.xcworkspace'

target 'ConvayMeetSDKTest' do
  project 'ConvayMeetSDKTest.xcodeproj'

  pod 'ConvayMeetSDK'
end
```

Replace `ConvayMeetSDKTest` with your project and target names.

Bitcode is not supported, so turn it off for your project.

The SDK uses Swift code, so make sure you select `Always Embed Swift Standard Libraries`
in your project.

Since the SDK requests camera and microphone access, make sure to include the
required entries for `NSCameraUsageDescription` and `NSMicrophoneUsageDescription`
in your `Info.plist` file.

In order for app to properly work in the background, select the "audio" and "voip"
background modes.

Last, since the SDK shows and hides the status bar based on the conference state,
you may want to set `UIViewControllerBasedStatusBarAppearance` to `NO` in your
`Info.plist` file.

## API

The API is documented [here](SDK_USAGE.md).
