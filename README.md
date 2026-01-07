# Convay Meet iOS SDK

This repository contains releases of the Convay Meet iOS SDK for iOS applications.

## 📦 SDK Information

- **SDK Version**: 1.0.0
- **Package Name**: `ConvayMeetSDK`
- **CocoaPods**: Available via GitHub (Private Repository)
- **Minimum iOS Version**: iOS 13.0
- **Dependencies**: All bundled in XCFramework (React Native, WebRTC, Giphy, etc.)

## 🔐 Private Repository Access

This is a **private repository**. To access the SDK, you need:

1. **GitHub Access**: Ensure you have access to the repository `Synesis-IT-PLC/convay-meet-ios-sdk-releases`
2. **GitHub Personal Access Token**: Create a token with `read:packages` scope
   - Go to https://github.com/settings/tokens
   - Generate new token (classic)
   - Select `read:packages` scope
   - Copy the token

## 🚀 Installation

### Option 1: Using CocoaPods (Recommended)

The easiest way to integrate the SDK is via CocoaPods.

#### Step 1: Configure GitHub Credentials

Since this is a private repository, you need to configure your GitHub credentials.

**Option A: Using git credential helper (Recommended)**

```bash
git config --global credential.helper osxkeychain
```

Then when prompted, enter your GitHub username and Personal Access Token (not password).

**Option B: Using environment variables**

```bash
export GITHUB_USERNAME=your_username
export GITHUB_TOKEN=ghp_your_token_here
```

#### Step 2: Add to Your Podfile

Add the following to your `Podfile`:

```ruby
pod 'ConvayMeetSDK', :git => 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases.git', :tag => 'ios-sdk-1.0.0'
```

Or use the podspec directly:

```ruby
pod 'ConvayMeetSDK', :podspec => 'https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/raw/ios-sdk-1.0.0/ConvayMeetSDK.podspec'
```

**Note**: Replace `1.0.0` with the version you want to use. Check [Releases](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases) for available versions.

#### Step 3: Install Dependencies

```bash
pod install
```

#### Step 4: Open Your Workspace

```bash
open YourApp.xcworkspace
```

The SDK and all its dependencies are automatically included. No additional setup required!

### Option 2: Manual Installation from GitHub Releases

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
```

### User Information

```swift
let userInfo = ConvayMeetUserInfo(displayName: "John Doe",
                                andEmail: "john@example.com",
                                andAvatar: URL(string: "https://example.com/avatar.png"))
builder.userInfo = userInfo
```

## 📋 Requirements

- **iOS**: 13.0 or later
- **Xcode**: 12.0 or later
- **Swift**: 5.0 or later
- **GitHub Access**: Access to the private repository

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

### Issue: Cannot access private repository
**Solution**: 
- Ensure you have access to the repository `Synesis-IT-PLC/convay-meet-ios-sdk-releases`
- Verify your GitHub Personal Access Token has `read:packages` scope
- Check that your token is valid and not expired
- Try using git credential helper: `git config --global credential.helper osxkeychain`

### Issue: Framework not found
**Solution**: 
- Ensure the XCFramework is properly added to your project
- Check that "Embed & Sign" is selected in Frameworks, Libraries, and Embedded Content
- Clean build folder (Cmd+Shift+K) and rebuild

### Issue: Build errors
**Solution**: 
- Ensure you're using Xcode 12.0 or later
- Check that your deployment target is iOS 13.0 or later
- Clean build folder and derived data

### Issue: Conference not joining
**Solution**: 
- Verify server URL is correct
- Check network permissions
- Ensure room name is valid
- Check console logs for detailed error messages

### Issue: CocoaPods authentication failed
**Solution**: 
- Ensure your GitHub token has `read:packages` scope
- Try using git credential helper
- Verify you have access to the private repository
- Check that the repository URL is correct

## 📝 Notes

- The SDK includes a pre-bundled JavaScript bundle, so you don't need Metro bundler running
- The SDK is built in release mode by default
- All React Native dependencies are included in the SDK
- The SDK uses XCFramework format for universal binary support (iOS device + simulator)
- This is a **private repository** - ensure you have proper access before attempting to install

## 📦 Releases

See [Releases](https://github.com/Synesis-IT-PLC/convay-meet-ios-sdk-releases/releases) for all available versions.

## 📄 License

Apache License 2.0

## 🤝 Support

For issues and questions, please contact the development team or refer to the main project documentation.
