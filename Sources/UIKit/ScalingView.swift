//
//  ScalingView.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import UIKit

public typealias ScalingViewContentView = ScalingViewContentViewProtocol & UIView
public protocol ScalingViewContentViewProtocol: AnyObject {
    var contentSize: CGSize? { get }
}

public class ScalingView<ContentView: ScalingViewContentView>: UIScrollView {
    public let contentView: ContentView

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(contentView: ContentView) {
        self.contentView = contentView
        super.init(frame: .zero)
        configureContentViews()
    }

    private func configureContentViews() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        backgroundColor = .clear
        decelerationRate = .fast
        contentInsetAdjustmentBehavior = .never
        addSubview(contentView)
    }

    public var isContentZoomed: Bool {
        return zoomScale > minimumZoomScale
    }

    public func updateContentSize() {
        minimumZoomScale = 1
        maximumZoomScale = 1
        zoomScale = 1

        let contentSize = contentView.contentSize ?? .zero
        self.contentSize = contentSize
        contentView.frame = contentSize.rect
        updateZoomScale()
    }

    public private(set) var aspectFillZoomScale: CGFloat = 0
    private func updateZoomScale() {
        guard let contentSize = contentView.contentSize, contentSize != .zero else { return }

        let scaleWidth = bounds.width / contentSize.width
        let scaleHeight = bounds.height / contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        minimumZoomScale = minScale

        aspectFillZoomScale = max(scaleWidth, scaleHeight)
        maximumZoomScale = max(minScale * 2, aspectFillZoomScale * 2)

        zoomScale = minimumZoomScale
    }

    public func moveContentToCenter() {
        let horizontalInset = max(bounds.width - contentSize.width, 0) * 0.5
        let verticalInset = max(bounds.height - contentSize.height, 0) * 0.5

        contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }

    override public var frame: CGRect {
        didSet {
            guard oldValue != frame else { return }
            updateZoomScale()
            moveContentToCenter()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        moveContentToCenter()
    }

    // workaround :
    // PanningGesture(interactive dismiss) doesn't work when `contentSize.height` and `size.height` is different.
    override public var contentSize: CGSize {
        didSet {
            let roundedSize = contentSize.rounded(.down)
            guard contentSize != roundedSize else { return }
            contentSize = roundedSize
        }
    }
}
