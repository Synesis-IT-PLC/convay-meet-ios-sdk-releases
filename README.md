# Convay Meet iOS SDK

This repository contains releases of the Convay Meet iOS SDK for iOS applications.

## 📦 SDK Information

- **SDK Version**: 1.0.3
- **Package Name**: `ConvayMeetSDK`
- **Swift Package Manager**: Available via GitHub (Public Repository)
- **Minimum iOS Version**: iOS 13.0
- **Dependencies**: All bundled in XCFramework (React Native, WebRTC, Giphy, etc.)

## 🚀 Installation

### Using Swift Package Manager (SPM) - Recommended

The easiest way to integrate the SDK is via Swift Package Manager.

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

#### Step 2: Verify Installation

The SDK and all its dependencies are automatically included. No additional setup required!

**Note**: Check [Releases](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases) for available versions.

### Alternative: Manual Installation from GitHub Releases

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

## 📱 Basic Integration

### Step 1: Import the SDK

```swift
import ConvayMeetSDK
```

### Step 2: Generate Meeting Room URL from API

**Important:** Meeting room URLs must be generated from the Convay Meeting API. You cannot use arbitrary room names.

**Step 1:** Call Start Meeting or Join Meeting API:
```
POST https://convay.com/services/vcmeetingsettings/meeting/calender/start-meeting?type=instant
Authorization: Bearer {authToken}
```

**Step 2:** Get response with `token` and `calendarId`:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "calendarId": "1234567890"
}
```

**Step 3:** Construct meeting room URL:
```
{meetingPanelBaseUrl}/{calendarId}?jwt={token}
```

roomName: `https://mergemeet.convay.com/0000019b-79db-e96c-0000-000000040688?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...`

**Note:** See [MEETING_API_DOCUMENTATION.md](MEETING_API_DOCUMENTATION.md) for complete API documentation.

### Step 3: Create Conference Options

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
    builder.serverURL = URL(string: "https://convay.com")
    builder.room = roomName
    builder.setFeatureFlag("prejoinpage.enabled", withValue: false)
}
```

### Step 4: Join a Conference

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
            builder.room = roomName
            
            // Feature flags
            builder.setFeatureFlag("prejoinpage.enabled", withValue: false)
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
    var pipViewCoordinator: PiPViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the view
        convayMeetView = ConvayMeetView()
        convayMeetView.delegate = self
        
        // Add to view hierarchy
        view.addSubview(convayMeetView)
        convayMeetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            convayMeetView.topAnchor.constraint(equalTo: view.topAnchor),
            convayMeetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            convayMeetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            convayMeetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Setup PiP coordinator
        pipViewCoordinator = PiPViewCoordinator(withView: convayMeetView)
        
        // Join conference
        let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL(string: "https://convay.com")
            builder.room = roomName
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
        pipViewCoordinator?.enterPictureInPicture()
    }
    
    func ready(toClose data: [AnyHashable : Any]!) {
        // Animate out and clean up
        UIView.animate(withDuration: 0.3, animations: {
            self.convayMeetView?.alpha = 0
        }) { _ in
            self.convayMeetView?.removeFromSuperview()
            self.convayMeetView = nil
            self.pipViewCoordinator = nil
        }
    }
}
```

### Custom Server Configuration

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
    // Custom server
    builder.serverURL = URL(string: "https://convay.com")
    builder.room = roomName
    
    // Subject
    builder.subject = "My Meeting"
}
```

### Feature Flags

Control which features are enabled:

```swift
builder.setFeatureFlag("prejoinpage.enabled", withValue: false)
builder.setFeatureFlag("chat.enabled", withValue: true)
builder.setFeatureFlag("invite.enabled", withValue: true)
builder.setFeatureFlag("recording.enabled", withValue: false)
builder.setFeatureFlag("live-streaming.enabled", withValue: false)
builder.setFeatureFlag("pip.enabled", withValue: true)
builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: true)
```

### User Information

```swift
let userInfo = ConvayMeetUserInfo(displayName: "John Doe",
                                andEmail: "john@example.com",
                                andAvatar: URL(string: "https://example.com/avatar.png"))
builder.userInfo = userInfo
```

### Using Token Authentication

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
    builder.token = "your-jwt-token-here"
    builder.serverURL = URL(string: "https://convay.com")
    builder.room = roomName
}
```

### Using Meeting Link

```swift
let options = ConvayMeetConferenceOptions.fromBuilder { (builder) in
    builder.meetingLink = "https://convay.com/m/j/meeting-id"
    builder.authToken = "your-auth-token-here"
}
```

## 📋 Requirements

- **iOS**: 13.0 or later
- **Xcode**: 12.0 or later
- **Swift**: 5.0 or later
- **GitHub Access**: Public repository - no authentication required

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

### Issue: Package not found
**Solution**: 
- Ensure you're using the correct repository URL: `https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases.git`
- Check your internet connection
- Try cleaning the build folder (Cmd+Shift+K) and rebuilding
- In Xcode, go to **File** → **Packages** → **Reset Package Caches**

### Issue: Framework not found
**Solution**: 
- Ensure the package is properly added to your target
- Check that "Embed & Sign" is selected in Frameworks, Libraries, and Embedded Content
- Clean build folder (Cmd+Shift+K) and rebuild
- Try resetting package caches in Xcode

### Issue: Build errors
**Solution**: 
- Ensure you're using Xcode 12.0 or later
- Check that your deployment target is iOS 13.0 or later
- Clean build folder and derived data
- Try resetting package caches

### Issue: Conference not joining
**Solution**: 
- Verify server URL is correct
- Check network permissions
- Ensure room name is valid
- Verify token is valid and not expired
- Check console logs for detailed error messages

### Issue: PiPViewCoordinator methods not found
**Solution**: 
- `PiPViewCoordinator` doesn't have `configureAsStickyView()`, `show()`, or `hide()` methods
- Add the `ConvayMeetView` directly to your view hierarchy using Auto Layout
- Use `UIView.animate` for show/hide animations
- Use `enterPictureInPicture()` method for PiP functionality

## 📝 Notes

- The SDK includes a pre-bundled JavaScript bundle, so you don't need Metro bundler running
- The SDK is built in release mode by default
- All React Native dependencies are included in the SDK
- The SDK uses XCFramework format for universal binary support (iOS device + simulator)
- This is a **public repository** - no authentication required for SPM installation
- `PiPViewCoordinator` is used for picture-in-picture functionality but requires manual view hierarchy management

## 📦 Releases

See [Releases](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases) for all available versions.

## 📄 License

Apache License 2.0

## 🤝 Support

For issues and questions, please contact the development team or refer to the main project documentation.
