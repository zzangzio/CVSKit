//
//  UIView.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

// MARK: - AutoresizingMask
extension UIView.AutoresizingMask {
    public static var flexibleAll: UIView.AutoresizingMask {
        return [.flexibleWidth, .flexibleHeight]
    }

    public static var flexibleVerticalMargin: UIView.AutoresizingMask {
        return [.flexibleTopMargin, .flexibleBottomMargin]
    }

    public static var flexibleHorizontalMargin: UIView.AutoresizingMask {
        return [.flexibleLeftMargin, .flexibleRightMargin]
    }

    public static var flexibleAllMargin: UIView.AutoresizingMask {
        return [.flexibleVerticalMargin, .flexibleHorizontalMargin]
    }

    public static var inflexibleLeftMargin: UIView.AutoresizingMask {
        return [.flexibleWidth, .flexibleRightMargin]
    }

    public static var inflexibleRightMargin: UIView.AutoresizingMask {
        return [.flexibleWidth, .flexibleLeftMargin]
    }

    public static var inflexibleTopMargin: UIView.AutoresizingMask {
        return [.flexibleHeight, .flexibleBottomMargin]
    }

    public static var inflexibleBottomMargin: UIView.AutoresizingMask {
        return [.flexibleHeight, .flexibleTopMargin]
    }
}


// MARK: - Geometry
extension UIView {
    public var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }

    public var size: CGSize {
        get { return frame.size }
        set { frame.size = newValue }
    }

    public var width: CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }

    public var height: CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }

    public func moveToVerticalCenter() {
        guard let superview = superview else { return }
        frame.origin.y = superview.height |- height
    }

    public func moveToHorizontalCenter() {
        guard let superview = superview else { return }
        frame.origin.x = superview.width |- width
    }

    public func moveToCenter() {
        guard let superview = superview else { return }
        frame.origin.y = superview.height |- height
        frame.origin.x = superview.width |- width
    }

    public func putAfter(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.x = viewFrame.maxX + gap
    }

    public func putBefore(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.x = viewFrame.minX - (view.width + gap)
    }

    public func putAbove(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.y = viewFrame.minY - (view.height + gap)
    }

    public func putBelow(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.y = viewFrame.maxY + gap
    }
}

// MARK: - Autolayout
extension UIView {
    public static func autoLayoutView() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    public func allConstraints(equalTo anchors: LayoutAnchorProvider) -> [NSLayoutConstraint] {
        return [topAnchor.constraint(equalTo: anchors.topAnchor),
                bottomAnchor.constraint(equalTo: anchors.bottomAnchor),
                leadingAnchor.constraint(equalTo: anchors.leadingAnchor),
                trailingAnchor.constraint(equalTo: anchors.trailingAnchor)
        ]
    }
}

extension NSLayoutDimension {
    @discardableResult
    public static func |= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
        return left.constraint(equalTo: right, multiplier: 1)
    }

    @discardableResult
    public static func |= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
        return left.constraint(equalToConstant: right)
    }

    @discardableResult
    public static func |= (left: NSLayoutDimension, right: (NSLayoutDimension, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(equalTo: right.0, multiplier: 1, constant: right.1)
    }
}

extension NSLayoutXAxisAnchor {
    @discardableResult
    public static func |= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(equalTo: right)
    }

    @discardableResult
    public static func |= (left: NSLayoutXAxisAnchor, right: (NSLayoutXAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(equalTo: right.0, constant: right.1)
    }
}

extension NSLayoutYAxisAnchor {
    @discardableResult
    public static func |= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(equalTo: right)
    }

    @discardableResult
    public static func |= (left: NSLayoutYAxisAnchor, right: (NSLayoutYAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(equalTo: right.0, constant: right.1)
    }
}

extension Array where Element == NSLayoutConstraint {
    public func activate() {
        NSLayoutConstraint.activate(self)
    }

    public func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}

// MARK: - SafeArea
public protocol LayoutAnchorProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UILayoutGuide: LayoutAnchorProvider {}
extension UIView: LayoutAnchorProvider {
    public var backportSafeAreaLayoutGuide: LayoutAnchorProvider {
        guard #available(iOS 11, *) else { return self }
        return safeAreaLayoutGuide
    }

    public var backportSafeAreaInsets: UIEdgeInsets {
        guard #available(iOS 11, *) else { return .zero }
        return safeAreaInsets
    }
}

// MARK: - lineViews

extension UIView {
    @discardableResult
    public func bottomLine(_ height: CGFloat = 1,
                           out: Bool = false,
                           configure: ((UIImageView) -> Void)? = nil) -> UIImageView {
        let tag = (hash + 90)
        let view = viewWithTag(tag) as? UIImageView ?? {
            let view = UIImageView()
            view.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
            view.tag = tag
            self.addSubview(view)
            return view
            }()
        let offsetY = out ? frame.height : frame.height - height
        view.frame = CGRect(x: 0, y: offsetY, width: frame.width, height: height)
        configure?(view)
        return view
    }

    @discardableResult
    public func topLine(_ height: CGFloat = 1,
                        out: Bool = false,
                        configure: ((UIImageView) -> Void)? = nil) -> UIImageView {
        let tag = (hash + 91)
        let view = viewWithTag(tag) as? UIImageView ?? {
            let view = UIImageView()
            view.autoresizingMask = .flexibleWidth
            self.addSubview(view)
            view.tag = tag
            return view
            }()
        let offsetY = out ? -height : 0
        view.frame = CGRect(x: 0, y: offsetY, width: frame.width, height: height)
        configure?(view)
        return view
    }

    @discardableResult
    public func leftLine(_ width: CGFloat = 1,
                         out: Bool = false,
                         configure: ((UIImageView) -> Void)? = nil) -> UIImageView {
        let tag = (hash + 92)
        let view = viewWithTag(tag) as? UIImageView ?? {
            let view = UIImageView()
            view.autoresizingMask = .flexibleHeight
            self.addSubview(view)
            view.tag = tag
            return view
            }()
        let offsetX = out ? -width : 0
        view.frame = CGRect(x: offsetX, y: 0, width: width, height: frame.height)
        configure?(view)
        return view
    }

    @discardableResult
    public func rightLine(_ width: CGFloat = 1,
                          out: Bool = false,
                          configure: ((UIImageView) -> Void)? = nil) -> UIImageView {
        let tag = (hash + 93)
        let view = viewWithTag(tag) as? UIImageView ?? {
            let view = UIImageView()
            view.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
            self.addSubview(view)
            view.tag = tag
            return view
            }()
        let offsetX = out ? frame.width : frame.width - width
        view.frame = CGRect(x: offsetX, y: 0, width: width, height: frame.height)
        configure?(view)
        return view
    }
}

// MARK: - Util
extension UIView {
    public var asImage: UIImage {
        return UIImage.create(size: size) { (context) in
            self.layer.render(in: context)
        }
    }

    public static var isRightToLeft: Bool {
        let direction = UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute)
        return direction == .rightToLeft
    }
}
