# SwiftyUTType

[![CI Status](https://img.shields.io/travis/NoodleOfDeath/SwiftyUTType.svg?style=flat)](https://travis-ci.org/NoodleOfDeath/SwiftyUTType)
[![Version](https://img.shields.io/cocoapods/v/SwiftyUTType.svg?style=flat)](https://cocoapods.org/pods/SwiftyUTType)
[![License](https://img.shields.io/cocoapods/l/SwiftyUTType.svg?style=flat)](https://cocoapods.org/pods/SwiftyUTType)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyUTType.svg?style=flat)](https://cocoapods.org/pods/SwiftyUTType)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftyUTType is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyUTType'
```

## Usage

### Generating from Strings and URLs

```swift
import SwiftyUTType

print("my-file.css".uttype) // prints "public.css"
print("my-file.html".uttype) // prints "public.html"
print("my-file.java".uttype) // prints "com.sun.java-source"
print("my-file.jpg".uttype) // prints "public.jpeg"
print("my-file.js".uttype) // prints "com.netscpe.javascript-source"
print("my-file.json".uttype) // prints "public.json"
print("my-file.md".uttype) // prints "dyn."; custom document type like this need to be specified in the Info.plist
print("my-file.mp4".uttype) // prints "public.mpeg-4"
print("my-file.plist".uttype) // prints "com.apple.property-list"
print("my-file.png".uttype) // prints "public.png"
print("my-file.swift".uttype) // prints "public.swift-source"
print("my-file.tiff".uttype) // prints "public.tiff"
print("my-file.txt".uttype) // prints "public.plain-text"

print(Bundle.main.url(forResource: "Info" , withExtension: "plist")!.uttype) // prints "com.apple.property-list"
```

### Testing for Conformance

```swift
import SwiftyUTType

print("my-file.jpg".uttype.conforms(to: .Image)) // prints "true"
print("my-file.jpg".uttype.conforms(to: .JPEG)) // prints "true"
print("my-file.jpg".uttype.conforms(to: .PNG)) // prints "false"
print("my-file.jpg".uttype.conforms(to: .PNG, .TIFF, .JPEG))  // prints "true"

print("my-file.png".uttype.conforms(to: .Image)) // prints "true"
print("my-file.png".uttype.conforms(to: .JPEG)) // prints "true"
print("my-file.png".uttype.conforms(to: .PNG))  // prints "true"
print("my-file.png".uttype.conforms(to: .PNG, .TIFF, .JPEG))  // prints "true"

print("my-file.mp4".uttype.conforms(to: .Video, .Movie)) // prints "true""

print("my-file.jpg".uttype.conforms(to: .Image, .JPEG, mustConformToAll: true))  // prints "true"
print("my-file.jpg".uttype.conforms(to: .Image, .PNG, mustConformToAll: true)) // prints "false"

print("my-file.png".uttype.conforms(to: .Image, .JPEG, mustConformToAll: true))  // prints "false"
print("my-file.png".uttype.conforms(to: .Image, .PNG, mustConformToAll: true)) // prints "true"

print("my-file.jpg".uttype.conforms(toFirst: .TIFF, .JPEG)!) // prints "public.jpeg"
print("my-file.jpg".uttype.conforms(toFirst: .TIFF, .Image, .JPEG)!) // prints "public.image"

print("my-file.png".uttype.conforms(toFirst: .TIFF, .JPEG))  // prints "nil"
print("my-file.png".uttype.conforms(toFirst: .TIFF, .Image, .JPEG)!) // prints "public.image"
```

## Author

NoodleOfDeath, git@noodleofdeath.com

## License

SwiftyUTType is available under the MIT license. See the LICENSE file for more info.
