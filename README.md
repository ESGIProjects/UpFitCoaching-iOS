# UpFit Coaching

To open the project, Xcode 9.3 is required. This app works with iOS 10.0 or higher, and takes into account iPhone screen sizes of 4-inch or higher.

## Lint

The project uses SwiftLint. This is optional, but highly recommanded.

To install Swiftlint, you can use *Homebrew*.

```
brew install swiftlint
```

## Associated projects

The **UpFit Coaching** app has an Android counterpart written in Java, available [here](https://bitbucket.org/esgi_5a/android). They communicate with a server written in Go available [there](https://bitbucket.org/esgi_5a/server).

## Dependencies

### Installation

Dependencies are managed with *CocoaPods*. If you don't have CocoaPods installed, run this command:

```
sudo gem install -n /usr/local/bin cocoapods
```

You can finally install the dependencies by running the following command inside the project directory:

```
pod install
```

### Used libraries

* Realm
* Starscream
* JTAppleCalendar
* Charts
* CryptoSwift
