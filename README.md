# Modern-OTP for Objective-C

Complete guide for integrating Modern-OTP into your Objective-C iOS project.

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS%2017%2B-blue" alt="Platform">
  <img src="https://img.shields.io/badge/Objective--C-Compatible-green" alt="Objective-C">
  <img src="https://img.shields.io/badge/SMS-Auto--Read-green" alt="SMS Auto-Read">
</p>

<p align="center">
  <img 
    src="https://github.com/user-attachments/assets/041979de-d31f-4414-9332-1152861244cc"
    width="200"
    height="300"
    alt="OTP Demo 1"
  />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img 
    src="https://github.com/user-attachments/assets/6653d812-5dcf-4811-b8e6-52c810ebf50b"
    width="200"
    height="300"
    alt="OTP Demo 2"
  />
</p>

****
## 📱 Features

- ✅ **Full Objective-C Support** - Works seamlessly in pure Objective-C projects
- 📱 **SMS Auto-Read** - Automatically detects OTP codes from SMS
- 🎨 **Beautiful Animations** - Success animations and particle effects
- 🎯 **Simple Integration** - Just 3 files to add
- ⚡ **Zero Configuration** - Works out of the box
- 🔒 **Secure** - Number-only keyboard with validation

## 📦 Installation

### Step 1: Add Swift Package

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter URL: `https://github.com/MahmoudAlaa92/Modern-OTP.git`
3. Select version `1.0.2` or later
4. Click **Add Package**

### Step 2: Create Swift Bridge

**Important:** Even though this is an Objective-C project, you need a Swift bridging header.

1. In Xcode: **File → New → File**
2. Select **Swift File**
3. Name it `Bridge.swift`
4. When prompted: **Click "Create Bridging Header"**
5. ✅ You can delete `Bridge.swift` after this (we just needed the bridging header)

### Step 3: Add OTPViewController.swift

Create a new Swift file called `OTPViewController.swift` in your project:

**File → New → File → Swift File → Name: `OTPViewController.swift`**

Copy this code:

```swift
//
//  OTPViewController.swift
//  
//  Objective-C bridge for Modern-OTP
//

import UIKit
import SwiftUI
import Modern_OTP

@objc public class OTPViewController: UIViewController {
    
    private var hostingController: UIHostingController<OTPContainerWrapper>?
    
    @objc public var onSuccess: (() -> Void)?
    @objc public var onError: (() -> Void)?
    
    private let expectedCode: String
    private let digitCount: Int
    
    @objc public init(expectedCode: String, digitCount: Int = 4) {
        self.expectedCode = expectedCode
        self.digitCount = digitCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let wrapperView = OTPContainerWrapper(
            expectedCode: expectedCode,
            digitCount: digitCount,
            onSuccess: { [weak self] in
                self?.onSuccess?()
            },
            onError: { [weak self] in
                self?.onError?()
            }
        )
        
        hostingController = UIHostingController(rootView: wrapperView)
        
        if let hostingController = hostingController {
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.view.frame = view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.didMove(toParent: self)
            hostingController.view.backgroundColor = .clear
        }
    }
}

// MARK: - SwiftUI Wrapper

struct OTPContainerWrapper: View {
    let expectedCode: String
    let digitCount: Int
    let onSuccess: () -> Void
    let onError: () -> Void
    
    @State private var isSuccess = false
    
    var body: some View {
        OTPContainerView(
            expectedCode: expectedCode,
            digitCount: digitCount,
            isSuccess: $isSuccess,
            onSuccess: onSuccess,
            onError: onError
        )
    }
}
```

## 🚀 Usage

### Basic Example

In your `ViewController.m`:

```objc
#import "ViewController.h"
#import "YourProjectName-Swift.h"  // Replace with your project name

@implementation ViewController

- (IBAction)showOTPButtonTapped:(id)sender {
    // Create OTP view controller
    OTPViewController *otpVC = [[OTPViewController alloc] 
        initWithExpectedCode:@"1234" 
        digitCount:4];
    
    // Success callback
    otpVC.onSuccess = ^{
        NSLog(@"✅ OTP verified successfully!");
        // Navigate to next screen or dismiss
    };
    
    // Error callback
    otpVC.onError = ^{
        NSLog(@"❌ Invalid OTP entered");
        // Handle error (optional)
    };
    
    // Present the OTP screen
    [self presentViewController:otpVC animated:YES completion:nil];
}

@end
```

### 6-Digit Code

```objc
OTPViewController *otpVC = [[OTPViewController alloc] 
    initWithExpectedCode:@"123456" 
    digitCount:6];
```

### With Navigation

```objc
- (IBAction)showOTP:(id)sender {
    OTPViewController *otpVC = [[OTPViewController alloc] 
        initWithExpectedCode:@"1234" 
        digitCount:4];
    
    otpVC.onSuccess = ^{
        // Navigate to home screen
        [self navigateToHome];
    };
    
    [self presentViewController:otpVC animated:YES completion:nil];
}

- (void)navigateToHome {
    // Dismiss OTP and navigate
    [self dismissViewControllerAnimated:YES completion:^{
        UIViewController *homeVC = [[UIViewController alloc] init];
        [self.navigationController pushViewController:homeVC animated:YES];
    }];
}
```

## 📱 SMS Auto-Read

**Works automatically!** No configuration needed.

When a user receives an SMS like:
```
Your verification code is: 1234
```

The code automatically fills in! ✨

### Requirements for Auto-Read

- ✅ Real iOS device (not simulator)
- ✅ iOS 12.0+
- ✅ Standard SMS format

### Testing

**On Real Device:**
1. Run your app
2. Send yourself SMS: "Your code is 1234"
3. Code auto-fills! 🎉

**In Simulator:**
- Auto-read won't work
- Manual entry works fine

## 📋 Complete Example Project

Here's a complete working example:

### ViewController.h
```objc
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@end
```

### ViewController.m
```objc
#import "ViewController.h"
#import "YourProjectName-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
}

- (IBAction)verifyButtonTapped:(id)sender {
    // Show OTP verification
    [self showOTPVerification];
}

- (void)showOTPVerification {
    // In production, get this code from your backend
    NSString *expectedCode = @"1234";
    
    OTPViewController *otpVC = [[OTPViewController alloc] 
        initWithExpectedCode:expectedCode 
        digitCount:4];
    
    // Configure success
    __weak typeof(self) weakSelf = self;
    otpVC.onSuccess = ^{
        NSLog(@"✅ Verification successful!");
        
        // Dismiss and show success
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [weakSelf showSuccessMessage];
        }];
    };
    
    // Configure error (optional)
    otpVC.onError = ^{
        NSLog(@"❌ Invalid code entered");
        // User can try again - OTP view stays open
    };
    
    // Present full screen
    otpVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:otpVC animated:YES completion:nil];
}

- (void)showSuccessMessage {
    UIAlertController *alert = [UIAlertController 
        alertControllerWithTitle:@"Success" 
        message:@"Phone number verified!" 
        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction 
        actionWithTitle:@"OK" 
        style:UIAlertActionStyleDefault 
        handler:^(UIAlertAction *action) {
            // Navigate to main app
            [self navigateToMainApp];
        }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)navigateToMainApp {
    // Your navigation logic here
    NSLog(@"Navigate to main app");
}

@end
```

### With Storyboard

1. **Add a Button** to your storyboard
2. **Control-drag** from button to `ViewController.m`
3. **Create Action:** `showOTP`
4. **Implement:**

```objc
- (IBAction)showOTP:(id)sender {
    OTPViewController *otpVC = [[OTPViewController alloc] 
        initWithExpectedCode:@"1234" 
        digitCount:4];
    
    otpVC.onSuccess = ^{
        NSLog(@"Success!");
    };
    
    [self presentViewController:otpVC animated:YES completion:nil];
}
```

## 🔧 Real-World Integration

### Login Flow Example

```objc
#import "LoginViewController.h"
#import "YourApp-Swift.h"

@implementation LoginViewController

- (IBAction)sendCodeButtonTapped:(id)sender {
    NSString *phoneNumber = self.phoneTextField.text;
    
    // Call your API to send SMS
    [self sendVerificationCodeToPhone:phoneNumber completion:^(NSString *code) {
        [self showOTPWithExpectedCode:code];
    }];
}

- (void)sendVerificationCodeToPhone:(NSString *)phone 
                          completion:(void (^)(NSString *code))completion {
    // TODO: Replace with your actual API call
    
    // Example API call
    NSDictionary *params = @{@"phone": phone};
    
    // Simulate API response
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), 
                   dispatch_get_main_queue(), ^{
        // In production, your API returns the code
        completion(@"1234");
    });
}

- (void)showOTPWithExpectedCode:(NSString *)code {
    OTPViewController *otpVC = [[OTPViewController alloc] 
        initWithExpectedCode:code 
        digitCount:4];
    
    otpVC.onSuccess = ^{
        NSLog(@"✅ Phone verified!");
        // Save login state and navigate
        [self completeLogin];
    };
    
    [self presentViewController:otpVC animated:YES completion:nil];
}

- (void)completeLogin {
    // Save authentication token
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
    
    // Navigate to main app
    // ...
}

@end
```

### Two-Factor Authentication

```objc
- (void)enable2FA {
    // Generate 2FA code via your backend
    [self request2FACode:^(NSString *code) {
        OTPViewController *otpVC = [[OTPViewController alloc] 
            initWithExpectedCode:code 
            digitCount:6];
        
        otpVC.onSuccess = ^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"2FAEnabled"];
            [self show2FAEnabledConfirmation];
        };
        
        [self presentViewController:otpVC animated:YES completion:nil];
    }];
}
```

## ⚠️ Troubleshooting

### Issue: "Use of undeclared identifier 'OTPViewController'"

**Solution:** Import the Swift bridge header:
```objc
#import "YourProjectName-Swift.h"
```

Replace `YourProjectName` with your actual project name.

### Issue: Bridge header not found

**Solution:**
1. Clean build folder: **Product → Clean Build Folder** (Cmd+Shift+K)
2. Build project: **Product → Build** (Cmd+B)
3. Check that `OTPViewController.swift` is in your project
4. Make sure bridging header was created in Step 2

### Issue: SMS auto-read not working

**Checklist:**
- ✅ Running on **real device** (not simulator)
- ✅ SMS format: "Your code is 1234"
- ✅ iOS 12 or later

### Issue: Success animation not showing

**Solution:** Make sure you're using the `OTPViewController.swift` code from Step 3 above. It uses `@State` for proper state management.

## 📊 Project Structure

Your Objective-C project should look like:

```
YourProject/
├── AppDelegate.h
├── AppDelegate.m
├── SceneDelegate.h
├── SceneDelegate.m
├── ViewController.h
├── ViewController.m
├── OTPViewController.swift          ← Add this file
├── YourProject-Bridging-Header.h    ← Created automatically
├── Main.storyboard
└── Info.plist
```

## 🎯 API Reference

### OTPViewController

```objc
// Initialize
OTPViewController *otpVC = [[OTPViewController alloc] 
    initWithExpectedCode:(NSString *)code 
    digitCount:(NSInteger)count];

// Properties
otpVC.onSuccess = ^{
    // Called when correct code is entered
};

otpVC.onError = ^{
    // Called when wrong code is entered
};

// Present
[self presentViewController:otpVC animated:YES completion:nil];
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `expectedCode` | `NSString *` | The correct OTP code (e.g., @"1234") |
| `digitCount` | `NSInteger` | Number of digits (default: 4) |

### Callbacks

| Callback | Description |
|----------|-------------|
| `onSuccess` | Called when user enters correct code |
| `onError` | Called when user enters wrong code |

## 📱 Requirements

- **iOS 17.0+**
- **Xcode 16.0+**
- **Objective-C** or **Swift** project

## 📄 License

Modern-OTP is available under the MIT license.

## 👨‍💻 Author

**Mahmoud Alaa**  
GitHub: [@MahmoudAlaa92](https://github.com/MahmoudAlaa92)

## 💬 Support

Need help?
- [Open an issue](https://github.com/MahmoudAlaa92/Modern-OTP/issues)
- [Start a discussion](https://github.com/MahmoudAlaa92/Modern-OTP/discussions)

## ⭐ Show Your Support

If Modern-OTP helped your project, please star the repository!

---

**Made with ❤️ for the Objective-C community**
