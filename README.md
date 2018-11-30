# Journal

Journal gives you a new way to think about logging in your application. You can log everything to the Journal Client application, where you can filter your logs to only see the relevant loglines.

It has all the needed logging features, so you can use it as the primary logging library in your application.

# Integration

## Cocoapods

Update your Podfile similarly:

```ruby
platform :ios, '10.0'

# You need to set target when you use CocoaPods 1.0.0 or later.
target 'SampleTarget' do
  use_frameworks!
  pod 'holloandris/Journal'
end
```

## Carthage

Add to your Cartfile:

```
github "holloandris/Journal"
```

# Usage

## Logging

Starting to use Journal is easy. Just add the Loggers and LoggingDetailProviders which you would like to use, and then use the five logging functions to log on the different logging levels:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    JournalProvider.shared.journal.add(logger: BonjourLogger())
    JournalProvider.shared.journal.add(logger: ConsoleLogger())
    JournalProvider.shared.journal.add(loggingDetailProvider: TimeLoggingDetailProvider())
    JournalProvider.shared.journal.add(loggingDetailProvider: ClassLoggingDetailProvider())
    
    return true
}

```

Logging from a class only needs the Journal to be imported, then you can use the macro functions:

```swift
import Journal

class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        error("Failed to load ExampleViewController", .customError)
        warning("Failed to load some resource")
        info("Example screen visible")
        debug("ExampleViewController was loaded")
        verbose("Called viewDidLoad()")
    }
    
}
```

## Journal Client application

Open the Journal Client application. It will immediately look for a running application which uses Journal, and after finding it it automatically connects.

To connect to the Journal Client, you have to be on the same network. It uses the same technology for discovery as AirPlay.

# How it works

The connection is made via WiFi using Bonjour as a discovery protocol.
