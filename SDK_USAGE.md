# Convay Meet iOS SDK - Usage Guide

This guide explains how to integrate and use the Convay Meet iOS SDK in your iOS application.

## 📦 SDK Information

- **SDK Version**: 1.0.1
- **Package Name**: `ConvayMeetSDK`
- **CocoaPods**: Available via GitHub
- **XCFramework Location**: `ios/sdk/out/ConvayMeetSDK.xcframework` (after build)
- **Local Build Location**: `local-ios-sdk/ConvayMeetSDK.xcframework`
- **Minimum iOS Version**: iOS 13.0
- **Dependencies**: All bundled in XCFramework (React Native, WebRTC, Giphy, etc.)

## 🚀 Quick Start

### Option 1: Using CocoaPods (Recommended)

The easiest way to integrate the SDK is via CocoaPods. The SDK is available from GitHub with all dependencies bundled.

#### Step 1: Add to Your Podfile

Add the following to your `Podfile`:

```ruby
pod 'ConvayMeetSDK', :git => 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases.git', :tag => 'ios-sdk-1.0.1'
```

Or use the podspec directly:

```ruby
pod 'ConvayMeetSDK', :podspec => 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/raw/ios-sdk-1.0.1/ConvayMeetSDK.podspec'
```

**Note**: Replace `1.0.1` with the version you want to use. Check [GitHub Releases](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases) for available versions.

#### Step 2: Install Dependencies

```bash
pod install
```

#### Step 3: Open Your Workspace

```bash
open YourApp.xcworkspace
```

The SDK and all its dependencies are automatically included. No additional setup required!


### Option 3: Manual Installation from GitHub Releases

If you prefer to download and integrate manually:

1. Download the XCFramework from the latest [GitHub Release](https://github.com/Synesis-IT-PLC/convay-meet-sdk-9646/releases)
2. Extract the zip file
3. Follow the "Manual Framework Import" steps above

## 📱 Basic Integration

### Step 1: Import the SDK

```swift
import ConvayMeetSDK
```

### Step 2: Create Conference Options

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
    builder.serverURL = URL(string: "https://convay.com")
    builder.room = "testRoom"
    builder.setFeatureFlag("welcomepage.enabled", withValue: false)
}
```

### Step 3: Join a Conference

```swift
// Using ConvayMeet singleton
ConvayMeet.sharedInstance().join(options)
```

Or using a view:

```swift
let convayMeetView = ConvayMeetView()
convayMeetView.join(options)
```

## 🎯 Complete Example

Here's a complete example of integrating the SDK:

```swift
import UIKit
import ConvayMeetSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func joinMeeting(_ sender: UIButton) {
        // Create conference options
        let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL(string: "https://convay.com")
            builder.room = "testRoom"
            
            
            // Feature flags
            builder.setFeatureFlag("welcomepage.enabled", withValue: false)
            builder.setFeatureFlag("chat.enabled", withValue: true)
            builder.setFeatureFlag("invite.enabled", withValue: true)
            
            // Audio/Video settings
            builder.audioOnly = false
            builder.videoMuted = false
        }
        
        // Join the conference
        ConvayMeet.sharedInstance().join(options)
    }
}
```

## 🔧 Advanced Configuration

### Using ConvayMeetView

For more control, use `ConvayMeetView`:

```swift
import UIKit
import ConvayMeetSDK

class ConferenceViewController: UIViewController, ConvayMeetViewDelegate {
    
    var convayMeetView: ConvayMeetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the view
        convayMeetView = ConvayMeetView()
        convayMeetView.delegate = self
        
        // Add to view hierarchy
        view.addSubview(convayMeetView)
        convayMeetView.frame = view.bounds
        
        // Join conference
        let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL(string: "https://convay.com")
            builder.room = "testRoom"
        }
        
        convayMeetView.join(options)
    }
    
    // MARK: - ConvayMeetViewDelegate
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print("Conference joined")
    }
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        print("Conference terminated")
        dismiss(animated: true)
    }
    
    func conferenceWillJoin(_ data: [AnyHashable : Any]!) {
        print("Conference will join")
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        print("Entered picture-in-picture")
    }
}
```

### Custom Server Configuration

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
    // Custom server
    builder.serverURL = URL(string: "https://convay.com")
    builder.room = "yourRoom"
    
    
    // Subject
    builder.subject = "My Meeting"
}
```

### Feature Flags

Control which features are enabled:

```swift
builder.setFeatureFlag("welcomepage.enabled", withValue: false)
builder.setFeatureFlag("chat.enabled", withValue: true)
builder.setFeatureFlag("invite.enabled", withValue: true)
builder.setFeatureFlag("recording.enabled", withValue: false)
builder.setFeatureFlag("live-streaming.enabled", withValue: false)
builder.setFeatureFlag("pip.enabled", withValue: true)
```

### User Information

```swift
let userInfo = ConvayMeetUserInfo(displayName: "John Doe",
                                andEmail: "john@example.com",
                                andAvatar: URL(string: "https://example.com/avatar.png"))
builder.userInfo = userInfo
```


## 📋 Requirements

- **iOS**: 12.0 or later
- **Xcode**: 12.0 or later
- **Swift**: 5.0 or later

## 🔐 Permissions

The SDK requires the following permissions in your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera for video calls</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for audio calls</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to share images</string>
```

## 🐛 Troubleshooting

### Issue: Framework not found
**Solution**: 
- Ensure the XCFramework is properly added to your project
- Check that "Embed & Sign" is selected in Frameworks, Libraries, and Embedded Content
- Clean build folder (Cmd+Shift+K) and rebuild

### Issue: Build errors
**Solution**: 
- Ensure you're using Xcode 12.0 or later
- Check that your deployment target is iOS 12.0 or later
- Clean build folder and derived data

### Issue: Conference not joining
**Solution**: 
- Verify server URL is correct
- Check network permissions
- Ensure room name is valid
- Check console logs for detailed error messages

### Issue: Swift Package Manager not working
**Solution**: 
- Ensure you're adding the local directory (not the XCFramework directly)
- The Package.swift file must be in the directory you're adding
- Try cleaning derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

## 📝 Notes

- The SDK includes a pre-bundled JavaScript bundle, so you don't need Metro bundler running
- The SDK is built in release mode by default
- All React Native dependencies are included in the SDK
- The SDK uses XCFramework format for universal binary support (iOS device + simulator)

## 📄 License

Apache License 2.0

## 🤝 Support

For issues and questions, please refer to the main project documentation or contact the development team.

