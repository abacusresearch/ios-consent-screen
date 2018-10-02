[![Carthage compatible](https://img.shields.io/badge/carthage-compatible-lightgrey.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/badge/pod-v0.0.1-lightgrey.svg?style=flat)](http://cocoadocs.org/)
![Platforms](https://img.shields.io/badge/platforms-iOS_9.0+-blue.svg?longCache=true&style=flat)
![Languages](https://img.shields.io/badge/languages-Swift%20%7C%20ObjC-orange.svg?longCache=true&style=flat)

# Setup
## Setup with Carthage
Add `github "abacusresearch/ios-consent-screen"` to your Cartfile and run carthage update.


## Setup with CocoaPods
`pod 'ConsentScreen', :git => 'https://github.com/fuggly/ios-consent-screen'`

# Compatibility
* Xcode
  * Language Support: **Swift** *(any version)*, **Objective-C**
  * Fully Compatible With: **Xcode 7.0**
* iOS
  * Compatible With: **iOS 9.0**

# Usage
## Present the ConsentScreen
### Swift
```
let vc = ConsentViewController()
vc.delegate = self
vc.modalPresentationStyle = UIModalPresentationStyle.formSheet // for iPads
vc.selectedOption = .fullReporting
self.present(vc, animated:true, completion: nil)
```
### Obj-C
```
ConsentViewController* vc = [ConsentViewController new];
vc.selectedOption = preferences.consent;
vc.delegate = self;
[self presentViewController:vc animated:YES completion:NULL];
```

## React to user's input
```
extension ViewController: ConsentScreenDelegate {
    public func consentScreenCommited(chosenOption: ConsentOption) {
        dismiss(animated: true) {
            print ("You chose option \(chosenOption.rawValue)")
        }
    }
}
```

