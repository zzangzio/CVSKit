//
//  UIView.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

// MARK: - AutoresizingMask

public extension UIView.AutoresizingMask {
    static var flexibleAll: UIView.AutoresizingMask {
        return [.flexibleWidth, .flexibleHeight]
    }

    static var flexibleVerticalMargin: UIView.AutoresizingMask {
        return [.flexibleTopMargin, .flexibleBottomMargin]
    }

    static var flexibleHorizontalMargin: UIView.AutoresizingMask {
        return [.flexibleLeftMargin, .flexibleRightMargin]
    }

    static var flexibleAllMargin: UIView.AutoresizingMask {
        return [.flexibleVerticalMargin, .flexibleHorizontalMargin]
    }

    static var inflexibleLeftMargin: UIView.AutoresizingMask {
        return [.flexibleWidth, .flexibleRightMargin]
    }

    static var inflexibleRightMargin: UIView.AutoresizingMask {
        return [.flexibleWidth, .flexibleLeftMargin]
    }

    static var inflexibleTopMargin: UIView.AutoresizingMask {
        return [.flexibleHeight, .flexibleBottomMargin]
    }

    static var inflexibleBottomMargin: UIView.AutoresizingMask {
        return [.flexibleHeight, .flexibleTopMargin]
    }
}

// MARK: - Geometry

public extension UIView {
    var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }

    var size: CGSize {
        get { return frame.size }
        set { frame.size = newValue }
    }

    var width: CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }

    var height: CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }

    func moveToVerticalCenter() {
        guard let superview = superview else { return }
        frame.origin.y = superview.height |- height
    }

    func moveToHorizontalCenter() {
        guard let superview = superview else { return }
        frame.origin.x = superview.width |- width
    }

    func moveToCenter() {
        guard let superview = superview else { return }
        frame.origin.y = superview.height |- height
        frame.origin.x = superview.width |- width
    }

    func putAfter(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.x = viewFrame.maxX + gap
    }

    func putBefore(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.x = viewFrame.minX - (view.width + gap)
    }

    func putAbove(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.y = viewFrame.minY - (view.height + gap)
    }

    func putBelow(of view: UIView, gap: CGFloat = 0) {
        guard let superview = superview else { return }
        let viewFrame = view.convert(view.bounds, to: superview)
        frame.origin.y = viewFrame.maxY + gap
    }
}

// MARK: - Autolayout

public extension UIView {
    static func autoLayoutView() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func allConstraints(equalTo anchors: LayoutAnchorProvider) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: anchors.topAnchor),
            bottomAnchor.constraint(equalTo: anchors.bottomAnchor),
            leadingAnchor.constraint(equalTo: anchors.leadingAnchor),
            trailingAnchor.constraint(equalTo: anchors.trailingAnchor),
        ]
    }
}

public extension NSLayoutDimension {
    @discardableResult
    static func |= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
        return left.constraint(equalTo: right, multiplier: 1)
    }

    @discardableResult
    static func |= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
        return left.constraint(equalToConstant: right)
    }

    @discardableResult
    static func |= (left: NSLayoutDimension, right: (NSLayoutDimension, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(equalTo: right.0, multiplier: 1, constant: right.1)
    }

    @discardableResult
    static func >= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
        return left.constraint(greaterThanOrEqualTo: right, multiplier: 1)
    }

    @discardableResult
    static func >= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
        return left.constraint(greaterThanOrEqualToConstant: right)
    }

    @discardableResult
    static func >= (left: NSLayoutDimension, right: (NSLayoutDimension, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(greaterThanOrEqualTo: right.0, multiplier: 1, constant: right.1)
    }

    @discardableResult
    static func <= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
        return left.constraint(lessThanOrEqualTo: right, multiplier: 1)
    }

    @discardableResult
    static func <= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
        return left.constraint(lessThanOrEqualToConstant: right)
    }

    @discardableResult
    static func <= (left: NSLayoutDimension, right: (NSLayoutDimension, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(lessThanOrEqualTo: right.0, multiplier: 1, constant: right.1)
    }
}

public extension NSLayoutXAxisAnchor {
    @discardableResult
    static func |= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(equalTo: right)
    }

    @discardableResult
    static func |= (left: NSLayoutXAxisAnchor, right: (NSLayoutXAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(equalTo: right.0, constant: right.1)
    }

    @discardableResult
    static func >= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(greaterThanOrEqualTo: right)
    }

    @discardableResult
    static func >= (left: NSLayoutXAxisAnchor, right: (NSLayoutXAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(greaterThanOrEqualTo: right.0, constant: right.1)
    }

    @discardableResult
    static func <= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(lessThanOrEqualTo: right)
    }

    @discardableResult
    static func <= (left: NSLayoutXAxisAnchor, right: (NSLayoutXAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(lessThanOrEqualTo: right.0, constant: right.1)
    }
}

public extension NSLayoutYAxisAnchor {
    @discardableResult
    static func |= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(equalTo: right)
    }

    @discardableResult
    static func |= (left: NSLayoutYAxisAnchor, right: (NSLayoutYAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(equalTo: right.0, constant: right.1)
    }

    @discardableResult
    static func >= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(greaterThanOrEqualTo: right)
    }

    @discardableResult
    static func >= (left: NSLayoutYAxisAnchor, right: (NSLayoutYAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(greaterThanOrEqualTo: right.0, constant: right.1)
    }

    @discardableResult
    static func <= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return left.constraint(lessThanOrEqualTo: right)
    }

    @discardableResult
    static func <= (left: NSLayoutYAxisAnchor, right: (NSLayoutYAxisAnchor, CGFloat)) -> NSLayoutConstraint {
        return left.constraint(lessThanOrEqualTo: right.0, constant: right.1)
    }
}

public extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }

    func deactivate() {
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
extension UIView: LayoutAnchorProvider {}

// MARK: - lineViews

public extension UIView {
    @discardableResult
    func bottomLine(
        _ height: CGFloat = 1,
        out: Bool = false,
        configure: ((UIImageView) -> Void)? = nil
    ) -> UIImageView {
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
    func topLine(
        _ height: CGFloat = 1,
        out: Bool = false,
        configure: ((UIImageView) -> Void)? = nil
    ) -> UIImageView {
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
    func leftLine(
        _ width: CGFloat = 1,
        out: Bool = false,
        configure: ((UIImageView) -> Void)? = nil
    ) -> UIImageView {
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
    func rightLine(
        _ width: CGFloat = 1,
        out: Bool = false,
        configure: ((UIImageView) -> Void)? = nil
    ) -> UIImageView {
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

public extension UIView {
    var asImage: UIImage {
        return UIImage.create(size: size) { context in
            self.layer.render(in: context)
        }
    }

    static var isRightToLeft: Bool {
        let direction = UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute)
        return direction == .rightToLeft
    }
}
