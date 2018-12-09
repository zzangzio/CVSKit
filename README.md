<p align="left">
<img src="https://github.com/zzangzio/CVSKit/blob/master/Logo.png" title="CVSKit">
</p>

[![CI Status](https://img.shields.io/travis/zzangzio/CVSKit.svg?style=flat)](https://travis-ci.org/zzangzio/CVSKit)
[![Version](https://img.shields.io/cocoapods/v/CVSKit.svg?style=flat)](https://cocoapods.org/pods/CVSKit)
[![License](https://img.shields.io/cocoapods/l/CVSKit.svg?style=flat)](https://cocoapods.org/pods/CVSKit)
[![Platform](https://img.shields.io/cocoapods/p/CVSKit.svg?style=flat)](https://cocoapods.org/pods/CVSKit)


CVSKit is a collection of Swift extensions and utility for better programming.

## Requirements
- **iOS** 10.0+
- Swift 4.2+


## Installation

CVSKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CVSKit'
```

## Features
### Foundation
<details>
<summary>String+Extension</summary>

```swift
extension String {
    func localized() -> String
    func localized(with arguments: CVarArg...) -> String
    var isValidEmail: Bool
    var trimming: String
    func toJsonObject() -> Any?
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/Foundation/String+Extension.swift">go to source</a>
</details>
<details>
<summary>OptionSet+Extension</summary>

```swift
extension OptionSet {
    func forEach(_ body: (Self) throws -> Void)
    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Self) -> Result) -> Result
    func enumerate() -> AnySequence<Self>
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/Foundation/OptionSet+Extension.swift">go to source</a>
</details>
<details>
<summary>Collection+Extension</summary>

```swift
extension Array {
    subscript(safe index: Int) -> Element?
    var any: Element?
}

extension Collection {
    func forEachStop(_ body: (Element, Int, inout Bool) -> Void)
}

extension Dictionary {
    static func += (left: inout [Key: Value], right: [Key: Value])
    static func + (left: [Key: Value], right: [Key: Value]) -> [Key: Value]
}

extension Array {
    func toJson(prettyPrint: Bool = false) -> String?
    func toJsonData(prettyPrint: Bool = false) -> Data?
}

extension Dictionary {
    func toJson(prettyPrint: Bool = false) -> String?
    func toJsonData(prettyPrint: Bool = false) -> Data?
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/Foundation/Collection+Extension.swift">go to source</a>
</details>
<details>
<summary>DispatchQueue+Extension</summary>

```swift
extension DispatchQueue {
    static var userInteractive: DispatchQueue
    static var userInitiated: DispatchQueue
    static var utility: DispatchQueue
    static var background: DispatchQueue

    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void)
    func async<Result>(execute: () -> Result, afterInMain mainExecute: (Result) -> Void)
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/Foundation/DispatchQueue+Extension.swift">go to source</a>
</details>
<details>
<summary>Numeric+Extension</summary>

```swift
extension BinaryInteger {
    static func |- (left: Self, right: Self) -> Self
}

extension BinaryFloatingPoint {
    static func |- (left: Self, right: Self) -> Self
}

extension BinaryInteger {
    var humanReadableFileSize: String
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/Foundation/Numeric+Extension.swift">go to source</a>
</details>
<details>
<summary>Date+Extension</summary>

```swift
public enum DateUnit {
    case day, month, year
}

extension Date {
    func startOfUnit(_ unit: DateUnit) -> Date
    func nextStartOfUnit(_ unit: DateUnit) -> Date
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/Foundation/Date+Extension.swift">go to source</a>
</details>


### CoreGraphics
<details>
<summary>CGSize+Extension</summary>

```swift
extension CGSize {
    var rect: CGRect
    var area: CGFloat
    func resized(constrainedPixel: Int, scale: CGFloat = UIScreen.main.scale) -> CGSize
    func resized(toScale: CGFloat) -> CGSize
    func resizedAspectFit(fitSize: CGSize) -> CGSize
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/CoreGraphics/CGSize+Extension.swift">go to source</a>
</details>
<details>
<summary>CGRect+Extension</summary>

```swift
extension CGRect {
    func intersectionRatio(_ r2: CGRect) -> CGFloat
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/CoreGraphics/CGRect+Extension.swift">go to source</a>
</details>

### UIKit
<details>
<summary>UIEdgeInsets+Extension</summary>

```swift
extension UIEdgeInsets {
    var horizontal: CGFloat
    var vertical: CGFloat
    var leftTop: CGPoint
    var rightBottom: CGPoint
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIEdgeInsets+Extension.swift">go to source</a>
</details>
<details>
<summary>UIColor+Extension</summary>

```swift
extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat = 1)
    convenience init(argb: Int)
    convenience init?(hex: String, alpha: CGFloat = 1)
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIColor+Extension.swift">go to source</a>
</details>
<details>
<summary>UIImage+Extension</summary>

```swift
extension UIImage {
    static func create(size: CGSize, opaque: Bool, scale: CGFloat, draw: (CGContext) -> Void) -> UIImage
    convenience init(color: UIColor, size: CGSize)
    var stretchable: UIImage
    static func createAsync(withData data: Data, completion: (UIImage?) -> Void)
    
    func with(alpha: CGFloat) -> UIImage
    func createAsync(withAlpha alpha: CGFloat, completion: (UIImage) -> Void)

    func with(tintColor: UIColor) -> UIImage
    func createAsync(withTintColor tintColor: UIColor, completion: (UIImage) -> Void)

    func with(edgeInsets: UIEdgeInsets, backgroundColor: UIColor) -> UIImage
    func createAsync(withEdgeInsets edgeInsets: UIEdgeInsets, completion:(UIImage) -> Void)

    func circled() -> UIImage
    func circledAsync(completion: (UIImage) -> Void)

    func squareCircled() -> UIImage
    func squareCircledAsync(completion: (UIImage) -> Void)

extension UIImage {
    func resized(toSize: CGSize, scale: CGFloat?) -> UIImage
    func resizedAsync(toSize: CGSize, scale: CGFloat?, completion: (UIImage) -> Void)

    func resized(withConstrainedPixel pixel: Int) -> UIImage
    func resizedAsync(withConstrainedPixel pixel: Int, completion:(UIImage) -> Void)

    func resized(withAspectFitSize fitSize: CGSize) -> UIImage
    func resizedAsync(withAspectFitSize fitSize: CGSize, completion: (UIImage) -> Void)

    func resized(withAspectFillSize fillSize: CGSize) -> UIImage
    func resizedAsync(withAspectFillSize fillSize: CGSize, completion: (UIImage) -> Void)
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIImage+Extension.swift">go to source</a>
</details>
<details>
<summary>HardwareModel</summary>

```swift
enum HardwareModel: String {
    case iPhone, iPhone4, iPhone5, ...
    case iPad, iPad2, iPadMini, ...
    case iPod1G, iPod2G, iPod3G, ...
    ...
    case unknown
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/HardwareModel.swift">go to source</a>
</details>
<details>
<summary>UIView+Extension</summary>

```swift
extension UIView.AutoresizingMask {
static var flexibleAll: UIView.AutoresizingMask { get }
    static var flexibleVerticalMargin: UIView.AutoresizingMask { get }
    static var flexibleHorizontalMargin: UIView.AutoresizingMask { get }
    static var flexibleAllMargin: UIView.AutoresizingMask { get }
    static var inflexibleLeftMargin: UIView.AutoresizingMask { get }
    static var inflexibleRightMargin: UIView.AutoresizingMask { get }
    static var inflexibleTopMargin: UIView.AutoresizingMask { get }
    static var inflexibleBottomMargin: UIView.AutoresizingMask { get }
}

extension UIView {
    var origin: CGPoint { get, set }
    var size: CGSize { get, set }
    var width: CGFloat { get, set }
    var height: CGFloat { get, set }
    func moveToVerticalCenter()
    func moveToHorizontalCenter()
    func moveToCenter()
    func putAfter(of view: UIView, gap: CGFloat) 
    func putBefore(of view: UIView, gap: CGFloat)
    func putAbove(of view: UIView, gap: CGFloat)
    func putBelow(of view: UIView, gap: CGFloat)
}

extension UIView {
    static func autoLayoutView() -> Self
    func allConstraints(equalTo anchors: LayoutAnchorProvider) -> [NSLayoutConstraint]
}

extension UIView {
var asImage: UIImage { get }
    static var isRightToLeft: Bool { get }
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIView+Extension.swift">go to source</a>
</details>
<details>
<summary>UIView+Animation</summary>

```swift
extension UIView {
    func startRotating(clockwise: Bool, duration: Double, repeatCount: Float)
    func stopRotating()
    func startPulse(fromScale: CGFloat, toScale: CGFloat, duration: CFTimeInterval, repeatCount: Float)
    func stopPulse()
    func fadeTransition(_ duration: CFTimeInterval)
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIView+Animation.swift">go to source</a>
</details>
<details>
<summary>UIImageView+Extension</summary>

```swift
extension UIImageView {
    static func autolayoutView(image: UIImage) -> Self
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIImageView+Extension.swift">go to source</a>
</details>
<details>
<summary>UIButton+Extension</summary>

```swift
extension UIButton {
    static func autoLayoutView(type: UIButton.ButtonType) -> Self
    func setSelectedTitle(_ title: String?)
    func setBackgroundImage(_ image: UIImage?)
    func setImage(_ image: UIImage?)
    func setSelectedImage(_ image: UIImage?)
    func setTitleColor(_ color: UIColor?)
    var title: String? { get, set }
}

extension UIButton {
    typealias ButtonAction = ((UIButton) -> Void)

    func setAction(_ action: ButtonAction?)
}

extension UIControl {
    func addTarget(_ target: Any?, action: Selector)
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIButton+Extension.swift">go to source</a>
</details>
<details>
<summary>UILabel+Extension</summary>

```swift
extension UILabel {
    static func autoLayoutView(font: UIFont?, color: UIColor?) -> Self
    convenience init(font: UIFont?, color: UIColor?)
    func sizeToFit(constrainedWidth: CGFloat)
}

extension UILabel {
    static func measureSize(withText text: String, font: UIFont, numberOfLines: Int, constrainedWidth: CGFloat, lineBreakMode: NSLineBreakMode) -> CGSize
    static func measureSize(withAttributedString string: NSAttributedString, numberOfLines: Int, constrainedWidth: CGFloat, lineBreakMode: NSLineBreakMode) -> CGSize
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UILabel+Extension.swift">go to source</a>
</details>
<details>
<summary>UITableView+Extension</summary>

```swift
protocol ReusableViewCell

extension UITableView {
    static func autoLayoutView(_ style: UITableView.Style) -> Self
    func dequeueReusableCell<Cell: ReusableViewCell>(initializer: (() -> Cell)?) -> Cell
    func hideSeparatorsForEmptyRows()
    var emptyDataView: UIView? { get, set }
    func reloadData(completion: @escaping (UITableView) -> Void)
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UITableView+Extension.swift">go to source</a>
</details>
<details>
<summary>UIBarButtonItem+Extension</summary>

```swift
extension UIBarButtonItem {
    func setTitleColor(_ color: UIColor?, for: UIControl.State)
    func setTitleFont(_ font: UIFont?, for: UIControl.State)
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIBarButtonItem+Extension.swift">go to source</a>
</details>
<details>
<summary>UIGestureRecognizer+Extension</summary>

```swift
extension UIGestureRecognizer {
    typealias GestureAction = ((UIGestureRecognizer) -> Void)
    func setAction(_ action: GestureAction?) 
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIGestureRecognizer+Extension.swift">go to source</a>
</details>
<details>
<summary>UIAlertController+Extension</summary>

```swift
extension UIAlertController {
    static func alert(withtitle title: String?, message: String?) -> UIAlertController
    static func actionSheet(withTitle title: String?, message: String?) -> UIAlertController
    static func actionSheet(withTitle title: String?, message: String?, sourceView: UIView, sourceRect: CGRect) -> UIAlertController

    func addDefaultAction(title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController 
    func addCancelAction(title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController
    func addDestructiveAction(title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/UIAlertController+Extension.swift">go to source</a>
</details>
<details>
<summary>SensitiveButton</summary>

```swift
class SensitiveButton: UIButton {
    let hitTester = SensitiveHitTester()
}

class SensitiveHitTester: NSObject {
    var extraHitEdgeInsets: UIEdgeInsets
    func point(inside point: CGPoint, bounds: CGRect, with event: UIEvent?) -> Bool
}
```
<a href="https://github.com/zzangzio/CVSKit/blob/master/Sources/UIKit/SensitiveButton.swift">go to source</a>
</details>

## Author

zzangzio, zzangzio@gmail.com

## License

CVSKit is available under the MIT license. See the LICENSE file for more info.
