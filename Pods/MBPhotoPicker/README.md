## MBPhotoPicker

Easy and quick in implementation Photo Picker, based on Slack's picker.

![picture alt](https://github.com/mbutan/MBPhotoPicker/blob/master/Assets/screenshot.png "MBPhotoPicker")

## Requirements
* iOS 9.0+
* Swift 3
* ARC
* To happy full functionality, expand your Xcode's captabilities of iCloud entitlement (see at the attached example, or read more about [here](https://developer.apple.com/library/mac/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html))

## Installation

MBPhotoPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MBPhotoPicker"
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

For a quick start see the code below.
``` swift
var photo: MBPhotoPicker = MBPhotoPicker()
photo.onPhoto = { (image: UIImage!) -> Void in
print("Selected image")
}
photo.onCancel = {
print("Cancel Pressed")
}
photo.onError = { (error) -> Void in
print("Error: \(error.rawValue)")
}
photo.present(self)
```

To disable import image from external apps, just type code:

```swift
photo.disableEntitlements = true
```

Library supports bunch of localizated strings, to override translations just use one of available variables:

``` swift
alertTitle
alertMessage
actionTitleCancel
actionTitleTakePhoto
actionTitleLastPhoto
actionTitleOther
actionTitleLibrary
```

## Author

Marcin Butanowicz, m.butan@gmail.com

Andrea Antonioni, andreaantonioni97@gmail.com (Contributor)

## License

MBPhotoPicker is available under the MIT license. See the LICENSE file for more info.
