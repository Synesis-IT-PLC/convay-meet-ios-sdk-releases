# Convay Meet iOS SDK

The Convay Meet iOS SDK provides the same user experience as the Convay Meet app, in a customizable way which you can embed in your apps.

> **Important**: iOS 13.0 or higher is required.

## Sample applications using the SDK

If you want to see how easy integrating the Convay Meet SDK into a native application is, take a look at the [sample applications repository](https://github.com/Synesis-IT-PLC/convay-meet-sdk-samples/tree/main/iOS).

## Usage

There are 3 ways to integrate the SDK into your project:

* Using Swift Package Manager (SPM) - Recommended
* Using CocoaPods
* Manual installation from GitHub Releases

### Using Swift Package Manager

The recommended way for using the SDK is by using Swift Package Manager.

#### Step 1: Add Package in Xcode

1. Open your project in Xcode
2. Go to **File** → **Add Package Dependencies...**
3. Enter the repository URL:
   ```
   https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases.git
   ```
4. Select the version you want to use (or use the latest version)
5. Click **Add Package**
6. Select the `ConvayMeetSDK` product and add it to your target
7. Click **Add Package**

The SDK and all its dependencies are automatically included. No additional setup required!

**Note**: Check [Releases](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases) for available versions.

#### Step 2: Configure Info.plist

Since the SDK requests camera and microphone access, make sure to include the required entries for `NSCameraUsageDescription` and `NSMicrophoneUsageDescription` in your `Info.plist` file:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera for video calls</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for audio calls</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to share images</string>
```

In order for app to properly work in the background, select the "audio" and "voip" background modes in your target's **Signing & Capabilities** tab.

Since the SDK shows and hides the status bar based on the conference state, you may want to set `UIViewControllerBasedStatusBarAppearance` to `NO` in your `Info.plist` file.

#### Step 3: Configure AppDelegate

Your `AppDelegate` needs to include the following setup for the SDK to work properly:

```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setenv("OBJC_DISABLE_LOADING_WEAK_LIBRARIES", "1", 1)
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        return true
    }
}
```

**Important:**
- The `setenv("OBJC_DISABLE_LOADING_WEAK_LIBRARIES", "1", 1)` call is required for the SDK to function correctly
- The `window` property must be declared and initialized if it's `nil`
- This setup is required regardless of whether you're using Scene-based or traditional window-based app lifecycle

### Using CocoaPods

The SDK can also be integrated using CocoaPods. In order to do so, add the `ConvayMeetSDK` dependency to your existing `Podfile` or create a new one following this example:

```ruby
platform :ios, '13.0'

target 'YourApp' do
  pod 'ConvayMeetSDK', :podspec => 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/raw/main/ConvayMeetSDK.podspec'
end
```

Replace `YourApp` with your project and target names.

Then install the dependencies:

```bash
pod install
```

After installation, open your workspace:

```bash
open YourApp.xcworkspace
```

**Note**: Make sure to use the `.xcworkspace` file, not the `.xcodeproj` file when working with CocoaPods.

### Manual Installation from GitHub Releases

1. Download the XCFramework from the [GitHub Release](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases)
2. Extract the zip file
3. In Xcode, select your project in the Project Navigator
4. Select your app target
5. Go to **General** tab
6. Scroll to **Frameworks, Libraries, and Embedded Content**
7. Click the **+** button
8. Click **Add Other... → Add Files...**
9. Navigate to the extracted `ConvayMeetSDK.xcframework`
10. Click **Open**
11. Ensure **Embed & Sign** is selected

## API

ConvayMeet is an iOS framework which embodies the whole Convay Meet experience and makes it reusable by third-party apps.

To get started:

1. Add a `ConvayMeetView` to your app using a Storyboard or Interface Builder, for example.
2. Then, once the view has loaded, set the delegate in your controller and load the desired URL:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    let convayMeetView = ConvayMeetView()
    convayMeetView.delegate = self

}
```

### ConvayMeetView class

The `ConvayMeetView` class is the entry point to the SDK. It is a subclass of `UIView` which renders a full conference in the designated area.

#### delegate

Property to get/set the `ConvayMeetViewDelegate` on `ConvayMeetView`.

#### Start Meeting (Token Based)(_ options: ConvayMeetConferenceOptions)

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { builder in

   
   builder.authToken = authToken // REQUIRED
   builder.setFeatureFlag("startpage.enabled", withBoolean: true) // REQUIRED

   
   builder.userInfo = userInfo // Optional

   // Audio / Video defaults
   builder.setAudioMuted(false) // Optional
   builder.setVideoMuted(false) // Optional

   // Feature flags
   builder.setFeatureFlag("chat.enabled", withBoolean: true) // Optional
   builder.setFeatureFlag("invite.enabled", withBoolean: true) // Optional
   builder.setFeatureFlag("recording.enabled", withBoolean: false) // Optional
   builder.setFeatureFlag("pip.enabled", withBoolean: true) // Optional
   builder.setFeatureFlag("participants.enabled", withBoolean: false) // Optional

   // Screen sharing
   builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: false) // Optional

   // Disable mute buttons
   builder.setFeatureFlag("video-mute.enabled", withBoolean: false) // Optional
   builder.setFeatureFlag("audio-mute.enabled", withBoolean: false) // Optional
}
convayMeetView.join(options)

```

#### Join Meeting (link based)(_ options: ConvayMeetConferenceOptions)


Sample meeting link: https://convay.com/m/j/649779334794/raiyansharif?pwd=fb2f30e4532f6ed6c8486cc494560904


```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
   builder.setFeatureFlag("joinpage.enabled", withValue: true) // Required
   builder.meetingLink = meetingLink // Required
   
   builder.userInfo = userInfo // Optional

   // Audio / Video defaults
   builder.setAudioMuted(false) // Optional
   builder.setVideoMuted(false) // Optional

   // Feature flags
   builder.setFeatureFlag("chat.enabled", withBoolean: true) // Optional
   builder.setFeatureFlag("invite.enabled", withBoolean: true) // Optional
   builder.setFeatureFlag("recording.enabled", withBoolean: false) // Optional
   builder.setFeatureFlag("pip.enabled", withBoolean: true) // Optional
   builder.setFeatureFlag("participants.enabled", withBoolean: false) // Optional

   // Screen sharing
   builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: false) // Optional

   // Disable mute buttons
   builder.setFeatureFlag("video-mute.enabled", withBoolean: false) // Optional
   builder.setFeatureFlag("audio-mute.enabled", withBoolean: false) // Optional
}

convayMeetView.join(options)
```

#### leave()

Leaves the currently active conference.

#### hangUp()

The localParticipant leaves the current conference.

#### setAudioMuted(_ muted: Bool)

Sets the state of the localParticipant audio muted according to the `muted` parameter.

#### setVideoMuted(_ muted: Bool)

Sets the state of the localParticipant video muted according to the `muted` parameter.

#### sendEndpointTextMessage(_ message: String, to participantId: String?)

Sends a message via the data channel to one particular participant or to all of them. If the `participantId` param is `nil`, the message will be sent to all the participants in the conference.

In order to get the participantId, the `PARTICIPANT_JOINED` event should be listened for, which `data` includes the id and this should be stored somehow.

#### toggleScreenShare(_ enabled: Bool)

Sets the state of the localParticipant screen sharing according to the `enabled` parameter.

#### openChat(to participantId: String?)

Opens the chat dialog. If `participantId` contains a valid participantId, the private chat with that particular participant will be opened.

#### sendChatMessage(_ message: String, to participantId: String?)

Sends a chat message to one particular participant or to all of them. If the `participantId` param is `nil`, the message will be sent to all the participants in the conference.

In order to get the participantId, the `PARTICIPANT_JOINED` event should be listened for, which `data` includes the id and this should be stored somehow.

#### closeChat()

Closes the chat dialog.

#### retrieveParticipantsInfo(_ completionHandler: @escaping ([AnyHashable : Any]) -> Void)

Retrieves the participants information in the completionHandler sent as parameter.

### ConvayMeetViewDelegate

The `ConvayMeetViewDelegate` protocol allows you to respond to conference events.

#### conferenceWillJoin(_ data: [AnyHashable : Any]!)

Called when the conference is about to join.

#### conferenceJoined(_ data: [AnyHashable : Any]!)

Called when the conference has successfully joined.

```swift
func conferenceJoined(_ data: [AnyHashable : Any]!) {
    print("Conference joined - Data: \(String(describing: data))")
}
```

#### conferenceTerminated(_ data: [AnyHashable : Any]!)

Called when the conference has terminated.

```swift
func conferenceTerminated(_ data: [AnyHashable : Any]!) {
    print("Conference terminated")
    dismiss(animated: true)
}
```

#### ready(toClose data: [AnyHashable : Any]!)

Called when the SDK is ready to close. This is a good place to clean up the view.

```swift
func ready(toClose data: [AnyHashable : Any]!) {
    UIView.animate(withDuration: 0.3, animations: {
        self.convayMeetView?.alpha = 0
    }) { _ in
        self.convayMeetView?.removeFromSuperview()
        self.convayMeetView = nil
        self.pipViewCoordinator = nil
    }
}
```

#### enterPicture(inPicture data: [AnyHashable : Any]!)

Called when the user enters picture-in-picture mode.

```swift
func enterPicture(inPicture data: [AnyHashable : Any]!) {
    pipViewCoordinator?.enterPictureInPicture()
}
```

### Picture-in-Picture

ConvayMeetView will automatically adjust its UI when presented in a Picture-in-Picture style scenario, in a rectangle too small to accommodate its "full" UI.

Convay Meet SDK does not currently implement native Picture-in-Picture on iOS. If desired, apps need to implement non-native Picture-in-Picture themselves and resize ConvayMeetView.

If delegate implements enterPictureInPicture:, the in-call toolbar will render a button to afford the user to request entering Picture-in-Picture.

**Important Notes:**
- `PiPViewCoordinator` doesn't have `configureAsStickyView()`, `show()`, or `hide()` methods
- Add the `ConvayMeetView` directly to your view hierarchy using Auto Layout
- Use `UIView.animate` for show/hide animations
- Use `enterPictureInPicture()` method for PiP functionality

### Creating the Broadcast Upload Extension

1. In Xcode, go to **File** → **New** → **Target...**
2. Select **Broadcast Upload Extension** (without UI)
3. Name it (e.g., "BroadcastExtension")
4. Update deployment info to run in iOS 14 or newer
5. Make sure both the app and the extension are added to the same App Group

## Screen Sharing Integration

The SDK supports iOS screen sharing through a Broadcast Upload Extension. This allows users to share their screen during a conference.

#### TL;DR
- Add a Broadcast Upload Extension, without UI, to your app. Update deployment info to run in iOS 14 or newer.
- Copy SampleUploader.swift, SocketConnection.swift, DarwinNotificationCenter.swift and Atomic.swift files from the sample project to your extension. Make sure they are added to the extension's target.
- Add both the app and the extension to the same App Group. Next, add the app group id value to the app's Info.plist for the RTCAppGroupIdentifier key.
Add a new key RTCScreenSharingExtension to the app's Info.plist with the extension's Bundle Identifier as the value.
- Update SampleHandler.swift with the code from the sample project. Update appGroupIdentifier constant with the App Group name your app and extension are both registered to.
- Update ConvayMeetConferenceOptions to enable screen sharing using the ios.screensharing.enabled feature flag.
- Make sure voip is added to UIBackgroundModes, in the app's Info.plist, in order to work when the app is in the background.

### Setting up the Socket Connection

The extension needs to communicate with the SDK through a socket connection. You'll need to:

1. Add both the app and the extension to the same App Group
2. Add the app group id value to the app's `Info.plist` for the `RTCAppGroupIdentifier` key
3. Add a new key `RTCScreenSharingExtension` to the app's `Info.plist` with the extension's `Bundle Identifier` as the value


**Important Notes:**
- **REQUIRED**: You must replace `"YOUR_APPGROUP.appgroup"` in the `Constants` enum with your actual App Group identifier. This must match the App Group you configured in your Xcode project for both the main app and the Broadcast Upload Extension. Example: `"group.com.yourcompany.yourapp.appgroup"`
- Make sure all these files are added to your Broadcast Upload Extension target
- The `SampleUploader` uses the `@Atomic` property wrapper from `Atomic.swift`
- The App Group identifier must be the same in both your main app and the Broadcast Upload Extension

### Enabling Screen Sharing

Enable screen sharing in your conference options:

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
    builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: true)
    // ... other options
}
```

**Important:** Make sure `voip` is added to `UIBackgroundModes` in your app's `Info.plist` for screen sharing to work when the app is in the background.


## Requirements

- **iOS**: 13.0 or later
- **Xcode**: 12.0 or later
- **Swift**: 5.0 or later

## Notes

- The SDK includes a pre-bundled JavaScript bundle, so you don't need Metro bundler running
- The SDK is built in release mode by default
- All React Native dependencies are included in the SDK
- The SDK uses XCFramework format for universal binary support (iOS device + simulator)
- This is a **public repository** - no authentication required for SPM installation

## Releases

See [Releases](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases) for all available versions.

## License

Apache License 2.0

## Support

For issues and questions, please contact the development team or refer to the main project documentation.
