# NeatTipView
[![Version](https://img.shields.io/cocoapods/v/NeatTipView.svg?style=flat&colorA=000000)](http://cocoapods.org/pods/NeatTipView)
[![License](https://img.shields.io/cocoapods/l/NeatTipView.svg?style=flat&colorA=000000)](http://cocoapods.org/pods/NeatTipView)
[![Platform](https://img.shields.io/cocoapods/p/NeatTipView.svg?style=flat&colorA=000000)](http://cocoapods.org/pods/NeatTipView)


## [Live Docs](https://rootstrap.github.io/NeatTipView/)

## What is it?
NeatTipView allows you to display message tooltips that can be used as call to actions or informative tips.
- [x] Allows Different tip positionings.
- [x] Multiple animation styles.
- [x] Smart placement for dynamic strings.
- [x] Full NSAttributtedString support.

<img src="https://github.com/rootstrap/NeatTipView/blob/master/tipViewsExample.gif" height="440">

## Installation

NeatTipView is available through [CocoaPods](http://cocoapods.org) and [Carthage]().
### Cocoapods
To install it, simply add the following line to your Podfile:
```ruby
pod "NeatTipView"
```

### Carthage

To install it, simply add the following line to your Cartfile:
```
github "rootstrap/NeatTipView"
```

## Usage

### 1. Customize your preferences
Preferences are encapsulated inside the `NeatViewPreferences` struct, check the inline docs for more info about which customization points are available.

Example:

```swift
  var preferences = NeatViewPreferences()
  preferences.animationPreferences.appearanceAnimationType = .fromBottom
  preferences.animationPreferences.disappearanceAnimationType = .toBottom
```

### 2. Initialize and Present the tip
```swift
  let tipView = NeatTipView(
    superview: view,
    centerPoint: center,
    attributedString: attributedString(),
    preferences: preferences,
    arrowPosition: arrowPosition
  )
  tipView.show()
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## License

NeatTipView is available under the MIT license. See the LICENSE file for more info.

## Credits

**NeatTipView** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/NeatTipView/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
